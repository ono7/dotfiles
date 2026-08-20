import os

import prisma_sase

sdk = prisma_sase.API(ssl_verify=False)
CLIENT_ID = os.environ.get("PRISMA_CLIENT_ID") or os.environ.get("PRISMASASE_CLIENT_ID")
CLIENT_SECRET = os.environ.get("PRISMA_CLIENT_SECRET") or os.environ.get(
    "PRISMASASE_CLIENT_SECRET"
)
TSG_ID = os.environ.get("PRISMA_TSG_ID") or os.environ.get("PRISMASASE_TSG_ID")

auth_result = sdk.interactive.login_secret(
    client_id=CLIENT_ID, client_secret=CLIENT_SECRET, tsg_id=TSG_ID
)

if not auth_result:
    print("Authentication failed.")
    exit(1)

# Fetch all sites
response = sdk.get.sites()

if response.sdk_status:
    # print("Successfully retrieved sites:\n")
    # Pretty print the JSON output of the sites
    prisma_sase.jd(response.sdk_content)
else:
    print(f"Error fetching sites: {response.sdk_content}")
