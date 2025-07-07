## Python thread pattern

```python


import logging
import os
from concurrent.futures import ThreadPoolExecutor, as_completed

import prisma_sase
from requests.adapters import HTTPAdapter

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


MAX_POOL = 50


def tenant_id_mapper(s: str) -> str:
    """Return tenant map."""
    return tenant_ids.get(s, "sdwan-ssot-not-defined")


def get_interfaces(conn, site_id, element_id, hostname):
    """Gets interfaces for given device -> element_id."""
    try:
        ints = conn.get.interfaces(site_id, element_id).json()["items"]
        # print(f"device {hostname} has {len(ints)} interfaces")
        return ints

    except Exception as e:
        print(
            f"Device: {hostname}, id: {element_id}, unablet to get interfaces, error: {e}"
        )
        return []


def connect_to_api():
    """Establish connection to StrataCloud | update."""
    adapter = HTTPAdapter(
        pool_connections=MAX_POOL,
        pool_maxsize=MAX_POOL,
    )
    try:
        sdk = prisma_sase.API(
            "https://api.sase.paloaltonetworks.com",
            ssl_verify=False,
            update_check=False,
        )
        sdk.update_session_adapter(adapter)
        # default 240 (seconds)
        sdk.rest_call_timeout = 120
        sdk.interactive.login_secret(
            client_id=os.getenv("SDWAN_CLIENT_ID"),
            client_secret=os.getenv("SDWAN_TOKEN"),
            tsg_id=os.getenv("SDWAN_TENANT_ID"),
        )
        return sdk
    except Exception as e:
        print(f"Failed to connect to StrataCloud | update: {e!s}")


def collect_inventory(sdk, max_workers=MAX_POOL):
    """Collect basic device info and then gather interfaces concurrently.

    Hopefully the stratacloud API can handle this... :)
    If not, just set max_workers to 1
    """
    devices = []

    try:
        response = sdk.get.elements()
        if not response.cgx_status:
            logger.error("Failed to retrieve elements from API")
            return devices

        sitelist = response.cgx_content.get("items", [])
        if not sitelist:
            logger.warning("No devices found in inventory")
            return devices

        # First collect base device info without interfaces
        for site in sitelist:
            device_name = site.get(
                "name", f"unknown-sdwan-for-sn-{site.get('serial_number')}"
            )
            site_id = site.get("site_id")
            device_id = site.get("id")

            device_data = {
                "hostname": device_name,
                "platform": site.get("model_name"),
                "version": site.get("software_version"),
                "status": str(site.get("connected", False)),
                "serial": site.get("serial_number"),
                "id": device_id,
                "tenant_id": site.get("tenant_id"),
                "role": site.get("role"),
                "site_id": site_id,
                "interfaces": [],  # Placeholder
            }
            devices.append(device_data)

        with ThreadPoolExecutor(max_workers=max_workers) as executor:
            futures = {
                executor.submit(
                    get_interfaces, sdk, d["site_id"], d["id"], d["hostname"]
                ): d
                for d in devices
            }

            for future in as_completed(futures):
                device = futures[future]
                try:
                    device["interfaces"] = future.result()
                except Exception as e:
                    logger.error(
                        f"Failed to fetch interfaces for {device['hostname']}: {e}"
                    )

    except Exception as e:
        logger.exception(f"Error during inventory collection: {e}")

    return devices

```
