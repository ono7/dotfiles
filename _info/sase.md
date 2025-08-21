```python

import argparse
import json
import logging
import os
import sys
import time
from csv import DictReader
from os import getenv

# Add the script's directory to Python path
script_dir = os.path.dirname(os.path.abspath(__file__))
if script_dir not in sys.path:
    sys.path.insert(0, script_dir)

import prisma_sase  # noqa: E402

from api_session import APISessionError, SessionManager  # noqa: E402
from job_tracker import JobStatusTracker  # noqa: E402

# Global Vars
SCRIPT_NAME = ""
SCRIPT_VERSION = "v1"

_log = logging.getLogger(__name__)
_handler = logging.StreamHandler(sys.stdout)
_formatter = logging.Formatter(
    "%(asctime)s %(levelname)s [%(name)s.%(funcName)s:%(lineno)d] %(message)s"
)
_handler.setFormatter(_formatter)
_log.addHandler(_handler)
_log.propagate = True

# Set log level based on DEBUG environment variable
debugLevel = int(getenv("DEBUG", "1"))
if debugLevel == 2:
    _log.setLevel(logging.DEBUG)
if debugLevel == 1:
    _log.setLevel(logging.INFO)
else:
    for handler in logging.root.handlers[:]:
        logging.root.removeHandler(handler)
    _log.setLevel(logging.INFO)
_log.info("init...")

PRISMASASE_CLIENT_ID = os.getenv("SDWAN_CLIENT_ID")
PRISMASASE_CLIENT_SECRET = os.getenv("SDWAN_TOKEN")
PRISMASASE_TSG_ID = os.getenv("SDWAN_TENANT_ID")

if not all([PRISMASASE_CLIENT_ID, PRISMASASE_CLIENT_SECRET, PRISMASASE_TSG_ID]):
    _log.error(
        "Missing one or more required environment variables, SDWAN_CLIENT_ID, SDWAN_TOKEN, SDWAN_TENANT_ID"
    )
    sys.exit(1)


rnqosprofile_id_name = {}
rnqosprofile_name_id = {}
pa_region_spn = {}
site_id_name = {}
site_name_id = {}
default_qos_profile_id = None
wannw_id_name = {}
wannw_name_id = {}
wannw_label_id_name = {}
wannw_label_name_id = {}
pa_region_name_value = {}
pa_region_name_aggregate_region = {}

BATCH_SIZE = 15


def get_managed_session():
    """
    Alternative: Use the SessionManager for long-running processes.

    This approach creates a singleton session that's shared across
    the entire script lifecycle.

    Returns:
        AutoRefreshAPISession: The managed session instance
    """
    session_manager = SessionManager()

    # Initialize if not already done
    try:
        session_manager.initialize(
            client_id=PRISMASASE_CLIENT_ID,
            client_secret=PRISMASASE_CLIENT_SECRET,
            tsg_id=PRISMASASE_TSG_ID,
            refresh_buffer=180,
        )
        return session_manager.get_session()
    except APISessionError as e:
        _log.error(f"Failed to initialize session manager: {e}")
        sys.exit(1)


def check_response(r):
    if r.status_code not in (200, 201):
        _log.error(f"Invalid API response: {r.status_code}")


def tunnels(sase_session, site_list):
    tracker = JobStatusTracker()
    tracker.drop_table()

    global rnqosprofile_id_name
    global rnqosprofile_name_id
    global pa_region_spn
    global site_id_name
    global site_name_id
    global default_qos_profile_id
    global wannw_id_name
    global wannw_name_id
    global wannw_label_id_name
    global wannw_label_name_id
    global pa_region_name_value
    global pa_region_name_aggregate_region

    _log.info("Getting PA Locations")
    resp = sase_session.rest_call(
        "https://api.sase.paloaltonetworks.com/sse/config/v1/locations", method="GET"
    )

    check_response(resp)
    if resp.cgx_status:
        itemlist = resp.cgx_content
        for item in itemlist:
            pa_region_name_value[item["display"]] = item["value"]
            pa_region_name_aggregate_region[item["display"]] = item["aggregate_region"]
    else:
        _log.error("Could not retrieve PA Locations")

    _log.info("Getting PA SPNs ")
    resp = sase_session.rest_call(
        "https://api.sase.paloaltonetworks.com/sse/config/v1/bandwidth-allocations",
        method="GET",
    )

    check_response(resp)
    if resp.cgx_status:
        itemlist = resp.cgx_content.get("data", None)
        for item in itemlist:
            pa_region_spn[item["name"]] = item["spn_name_list"]
    else:
        _log.error("Coult not retrieve PA SPNs")
        _log.error(json.dumps(resp, indent=4))
        sys.exit(1)

    _log.info("Getting RN QoS Profiles")
    resp = sase_session.rest_call(
        "https://api.sase.paloaltonetworks.com/sse/config/v1/qos-profiles?folder=Remote Networks",
        method="GET",
    )

    check_response(resp)

    if resp.cgx_status:
        qosprofiles = resp.cgx_content.get("data", None)
        for profile in qosprofiles:
            rnqosprofile_id_name[profile["id"]] = profile["name"]
            rnqosprofile_name_id[profile["name"]] = profile["id"]
            if profile["name"] == "Default Profile":
                default_qos_profile_id = profile["id"]

        if default_qos_profile_id is None:
            _log.error("No default QoS profile found for RN.\nExiting..")
            sys.exit(1)

    else:
        _log.error("Could not retrieve QoS Profiles for Remote Networks")

    _log.info("Getting WAN Networks")
    resp = sase_session.get.wannetworks()
    check_response(resp)

    if resp.cgx_status:
        wannetworks = resp.cgx_content.get("items", None)
        for wannw in wannetworks:
            wannw_id_name[wannw["id"]] = wannw["name"]
            wannw_name_id[wannw["name"]] = wannw["id"]
    else:
        _log.error("Could not retrieve Sites")
        prisma_sase.jd_detailed(resp)

    _log.info("Getting WAN Labels")
    resp = sase_session.get.waninterfacelabels()
    check_response(resp)

    if resp.cgx_status:
        wannetworks = resp.cgx_content.get("items", None)
        for wannw in wannetworks:
            wannw_label_id_name[wannw["id"]] = wannw["name"]
            wannw_label_name_id[wannw["name"]] = wannw["id"]
    else:
        _log.error("Could not retrieve Sites")
        prisma_sase.jd_detailed(resp)

    _log.info("Getting Sites")
    resp = sase_session.get.sites()
    check_response(resp)

    if resp.cgx_status:
        itemlist = resp.cgx_content.get("items", None)
        for item in itemlist:
            if item["element_cluster_role"] == "SPOKE":
                site_id_name[item["id"]] = item["name"]
                site_name_id[item["name"]] = item["id"]
    else:
        _log.error("Could not retrieve Sites")
        prisma_sase.jd_detailed(resp)

    # populate job table
    _log.info("Populating job_status table")
    for site in site_list:
        tracker.add_job(**site)

    for i in range(0, len(site_list), BATCH_SIZE):
        batch = site_list[i : i + BATCH_SIZE]
        _log.info(f">>>>> Starting batch {i} - {i + BATCH_SIZE} <<<<<")
        start = time.time()
        process_batch(sase_session, batch, tracker)
        end = time.time()
        delta = end - start
        _log.info(
            f">>>>> Batch complete for sites {i} - {i + BATCH_SIZE}, in {build_time(delta)} <<<<<"
        )
    return


def check_tunnel_errors(tunnel):
    """Check if tunnel has any error messages."""
    error_messages = tunnel.get("error_messages", {})
    if not error_messages:
        return False

    for _, v in error_messages.items():
        if "error" in v.lower():
            return True
    return False


def validate_tunnel_status(api_response, new_deployment=False):
    """
    Validates tunnel status from API response.

    Returns:
        tuple: (None, success_string) if all conditions pass
               (error_dict, "Errors detected") if validation fails
    """

    def clean_item(item):
        """Remove metadata fields from item."""
        cleaned = item.copy()
        fields_to_remove = [
            "id",
            "_etag",
            "_schema",
            "_created_on_utc",
            "_updated_on_utc",
            "_debug",
            "_info",
            "_warning",
            "_error",
        ]
        for field in fields_to_remove:
            cleaned.pop(field, None)
        return cleaned

    try:
        items = api_response.get("items", [])

        if not items:
            return "waiting", "in_progress"

        success_parts = []
        has_errors = False

        for item in items:
            # Check overall connection status
            if new_deployment:
                if item.get("connection_status") in ("NOT_CONNECTED", "IN_PROGRESS"):
                    return None, "in_progress"

            if item.get("connection_status") == "FAILED":
                has_errors = True
                continue

            # Check IPSec tunnel statuses
            tunnel_statuses = item.get("ipsec_tunnel_status", [])

            for tunnel in tunnel_statuses:
                tunnel_name = tunnel.get("name", "Unknown")

                # Check provisioning status
                prisma_status = tunnel.get("prismaaccess_tunnel_provisioning_status")
                branch_status = tunnel.get("branch_tunnel_provisioning_status")

                if prisma_status == "Failed" or branch_status == "Failed":
                    has_errors = True
                    continue

                uncompleted_steps = tunnel.get("uncompleted_steps", [])
                if uncompleted_steps:
                    return None, "in_progress"

                # Handle in_progress status
                if prisma_status == "IN_PROGRESS" or branch_status == "IN_PROGRESS":
                    return None, "in_progress"

                # Check for fully provisioned status
                if prisma_status != "Provisioned" or branch_status != "Provisioned":
                    has_errors = True
                    continue

                # If we reach here, tunnel is healthy
                success_parts.append(f"{tunnel_name} = UP")

        # Return results
        if has_errors:
            cleaned_items = [clean_item(item) for item in items]
            return {"error": cleaned_items}, "failed"

        success_string = ", ".join(success_parts)
        return success_string, "success"

    except Exception as e:
        return {"error": f"Failed to parse response: {str(e)}"}, "Errors detected"


def tunnel_state(sase_session, site_id):
    data = {"query_params": {"site_id": {"in": site_id}}}
    resp = sase_session.post.prismasase_connections_status_query(data=data)
    check_response(resp)
    return resp


def build_time(t):
    t = int(t)
    if t >= 60:
        return f"{t / 60:.2f} minutes"
    return f"{t} seconds"


def process_batch(sase_session, site_list, tracker):
    global rnqosprofile_id_name
    global rnqosprofile_name_id
    global pa_region_spn
    global site_id_name
    global site_name_id
    global default_qos_profile_id
    global wannw_id_name
    global wannw_name_id
    global wannw_label_id_name
    global wannw_label_name_id
    global pa_region_name_value
    global pa_region_name_aggregate_region

    sites_to_remove = []
    for site in site_list:

        job_id = site["job_number"]
        site_name = site["site_name"]
        try:
            site_id = site_name_id[site["site_name"]]
            tracker.update_job(job_id, site_id=site_id)

            region = pa_region_name_value[site["pa_location"]]
            spn_list = pa_region_spn[
                pa_region_name_aggregate_region[site["pa_location"]]
            ]
            spn_name = spn_list[int(site["spn"]) - 1]

        except Exception as e:
            _log.exception(e)
            tracker.update_job(job_id, results=f"{e}")
            sites_to_remove.append(site)
            continue

        edge_location = region
        name_rn_site = "{}_{}_ACT".format(
            site["site_name"].upper(), spn_name.replace("-", "").upper()
        )
        ipsec_tunnels = []
        enabled_wan = []

        resp = sase_session.get.waninterfaces(site_id=site_id)
        check_response(resp)
        if resp.cgx_status:
            swis = resp.cgx_content.get("items", None)
            for swi in swis:
                if swi["type"] == "publicwan":
                    enabled_wan.append(swi["id"])

                    updated_circuit_category = wannw_label_id_name[swi["label_id"]]

                    name = "{}_{}_ACT".format(
                        site["site_name"], updated_circuit_category
                    )

                    tunnelconf = {"name": name, "wan_interface_id": swi["id"]}
                    ipsec_tunnels.append(tunnelconf)
        else:
            msg = f"{site['site_name']}, unable to retrieve WAN Interfaces"
            _log.error(msg)
            tracker.update_job(job_id, results=msg)
            prisma_sase.jd_detailed(resp)

        if not enabled_wan:
            msg = "{site['site_name']}, no WAN circuits enabled"
            _log.error(msg)
            tracker.update_job(job_id, results=msg)
            sites_to_remove.append(site)

        resp = sase_session.get.prismasase_connections(site_id=site_id)
        check_response(resp)
        prismasase_connections = resp.cgx_content.get("items", None)

        if prismasase_connections:
            site_id = site_name_id[site["site_name"]]
            data = {"query_params": {"site_id": {"in": site_id}}}
            resp = sase_session.post.prismasase_connections_status_query(data=data)
            msg, status = validate_tunnel_status(resp.cgx_content)
            if status == "failed":
                _log.error(f"{site['site_name']}, error: {json.dumps(msg, indent=4)}")
                tracker.update_job(
                    job_id,
                    tunnel_status=json.dumps(msg, indent=4),
                    results=status,
                )

            elif status == "in_progress":
                tracker.update_job(
                    job_id,
                    tunnel_status=msg,
                    results=status,
                )

            elif status == "success":
                # the last state is UP
                tracker.update_job(
                    job_id,
                    tunnel_status=msg,
                    results=status,
                )
            else:
                _log.error("unknown state", status, msg)
            sites_to_remove.append(site)
            _log.info(f"{site['site_name']}, Tunnel exists, removed from job queue")
        else:
            data = {
                "is_active": True,
                "prismaaccess_edge_location": [edge_location],
                "prismaaccess_qos_profile_id": default_qos_profile_id,
                "prismaaccess_qos_cir_mbps": 1,
                "enabled_wan_interface_ids": enabled_wan,
                "ipsec_tunnel_configs": {
                    "anti_replay": False,
                    "copy_tos": False,
                    "tunnel_monitoring": True,
                    "enable_gre_encapsulation": False,
                },
                "routing_configs": {
                    "summarize_mobile_routes_before_advertise": False,
                    "export_routes": False,
                    "advertise_default_route": False,
                    "bgp_secret": None,
                },
                "remote_network_groups": [
                    {
                        "name": name_rn_site,
                        "ipsec_tunnels": ipsec_tunnels,
                        "spn_name": [spn_name],
                    }
                ],
                "is_enabled": True,
            }
            resp = sase_session.post.prismasase_connections(site_id=site_id, data=data)

            check_response(resp)
            time.sleep(1)
            if resp.cgx_status:
                tracker.update_job(
                    job_id,
                    tunnel_status="pending",
                    results="job sent, waiting on controller",
                )
                _log.info(f"{site['site_name']}, job sent, waiting on controller")
            else:
                msg = "{site['site_name']}, could not establish SASE Connection"
                _log.error(msg)
                tracker.update_job(job_id, results=msg)
                sites_to_remove.append(site)
                prisma_sase.jd_detailed(resp)

    for site in sites_to_remove:
        if site in site_list:
            site_list.remove(site)

    time.sleep(10)

    while site_list:

        if len(site_list) == 0:
            break

        sites_to_check = site_list[:]

        for site in sites_to_check:
            site_name = site["site_name"]
            site_id = site_name_id[site["site_name"]]
            job_id = site["job_number"]

            resp = tunnel_state(sase_session, site_id)
            msg, status = validate_tunnel_status(resp.cgx_content, new_deployment=True)
            if status == "success":
                site_list.remove(site)
                tracker.update_job(
                    job_id,
                    tunnel_status=msg,
                    results=status,
                )
                _log.info(f"{site_name}, Tunnels: {msg}")
            elif status == "failed":
                site_list.remove(site)
                tracker.update_job(
                    job_id,
                    tunnel_status=status,
                    results=f"{json.dumps(msg, indent=4)}",
                )
                _log.error(f"{site_name}, error: {json.dumps(msg, indent=4)}")
            elif status == "in_progress":
                tracker.update_job(
                    job_id,
                    tunnel_status=status,
                    results="waiting on controller",
                )
            else:
                _log.warning(
                    "unknown status: ",
                    status,
                    msg,
                    json.dumps(resp.cgx_content, indent=4),
                )

        if site_list:
            time.sleep(10)
    return


def go():
    ############################################################################
    # Begin Script, parse arguments.
    ############################################################################

    parser = argparse.ArgumentParser()

    # Allow Controller modification and debug level sets.
    config_group = parser.add_argument_group(
        "Config", "These options change how the configuration is generated."
    )
    config_group.add_argument("--file", "-F", help="File Name", required=True)

    args = vars(parser.parse_args())
    file_name = args["file"]

    sase_session = get_managed_session()

    site_list = []

    _log.info("Reading jobs")
    with open(file_name, "r") as read_obj:
        csv_dict_reader = DictReader(read_obj)
        for row in csv_dict_reader:
            site_list.append(row)

    _log.info(
        f">>>>> Processing: {len(site_list)} sites, in batches of {BATCH_SIZE} sites <<<<<"
    )

    start = time.time()
    tunnels(sase_session, site_list)
    end = time.time()

    delta = end - start

    _log.info(f"Total job runtime was {build_time(delta)}")


if __name__ == "__main__":
    go()

```
