```python

import os

import requests
import urllib3
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

MAX_POOL = 10
RETRY_STATUS_CODES = [429, 500, 502, 503, 504]
RETRY_METHODS = ["HEAD", "GET", "PUT", "POST", "DELETE"]


def get_api_session(verify_ssl: bool = False) -> requests.Session:
    """
    Creates and configures a requests.Session with required authentication headers,
    connection pooling, and retry logic.
    """
    session = requests.Session()
    session.verify = verify_ssl

    try:
        # fail fast with KeyError
        required_headers = {
            "session-key": os.environ["API_ID"],
            "session-othe": os.environ["API_KEY"],
            "Content-Type": "application/json",
        }

        session.headers.update(required_headers)

    except KeyError as e:
        raise EnvironmentError(
            f"Configuration Error: Missing required environment variable {str(e)}. "
            "Please ensure all Cradlepoint API keys are set."
        )

    retry_strategy = Retry(
        total=3,
        backoff_factor=1,  # Delay factor for backoff (1s, 2s, 4s, etc.)
        status_forcelist=RETRY_STATUS_CODES,
        allowed_methods=RETRY_METHODS,
    )

    adapter = HTTPAdapter(
        max_retries=retry_strategy,
        pool_connections=MAX_POOL,
        pool_maxsize=MAX_POOL,
    )

    session.mount("https://", adapter)
    session.mount("http://", adapter)

    return session

```
