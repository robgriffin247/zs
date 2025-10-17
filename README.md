# ZwiftScout

#### Setup

1. ``git clone git@github.com:robgriffin247/zs.git``
1. ``cd zs``
1. ``cp .streamlit/secrets_template.toml .streamlit/secrets.toml``
1. Add your API key to ``.streamlit/secrets.toml``
1. ``poetry install``

#### Data & Visualisation

1. Request data from ZRapp. In ``dlt/zwiftracing.py``
    ```
    ...
    load("rider", <rider_id>) # Requests a single rider using the GET endpoint; e.g. 4598636 is me
    load("riders", [<rider_id>, <rider_id>]) # Requests a single rider using the GET endpoint; e.g. load("riders", [4598636, 5574])
    load("club", <club_id>) # Requests (the first 1000) riders from a club e.g. load("club", 20650)
    ```
1. Run dbt
    ```
    poetry run dbt build
    ```
1. Streamlit app
    ```
    poetry run streamlit run ui/app.py
    ```
