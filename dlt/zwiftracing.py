import os
import dlt
import httpx
import json
import time

def load(resource, id):

    # These three functions all produce a list of dictionaries, with one dictionary per rider

    def get_riders(id):
        if isinstance(id, list) and isinstance(id[0], int):
            # Riders endpoint is using a POST and sends a list of ids as ints
            response = httpx.post(base_url, headers=header, json=id, timeout=30)
            response.raise_for_status()
            content = response.content
            decoded = content.decode(encoding="utf-8")
            riders = json.loads(decoded)
            # The output is a list of dictionaries
            return riders

        else:
            raise TypeError("Invalid input; expected a list of integers.")
        
    def get_club(id):
        if isinstance(id, int):
            # Makes a GET request with a single id
            response = httpx.get(f"{base_url}s/{id}", headers=header, timeout=30)
            response.raise_for_status()
            content = response.content
            decoded = content.decode(encoding="utf-8")
            club = json.loads(decoded)

            # Needs a restructure of club data into riders list
            # This: {"club":{"id":123, "name":"hello", "riders": < list of one dict per rider, like POST riders, but missing club info > } }
            # Becomes: [{"rider_id":1, ... , "club":{"id", "name"} }, ... ]
            riders = club["riders"]
            club_name = club["name"]
            for r in riders:
                r["club"] = {"id": id, "name":club_name}

            # This then replicates the structure from POST riders
            return riders

        else:
            raise TypeError("Invalid input; expected an integer.")

    def get_rider(id):
        if isinstance(id, int):
            # Also makes a GET with a single id
            response = httpx.get(f"{base_url}s/{id}", headers=header, timeout=30)
            response.raise_for_status()
            content = response.content
            decoded = content.decode(encoding="utf-8")
            riders = json.loads(decoded)
            # riders is just a single dictionary, so wrapped into a list
            return [riders]

        else:
            raise TypeError("Invalid input; expected an integer.")

    header = {"Authorization": os.getenv("ZRAPP_KEY")}
    base_url = f"https://zwift-ranking.herokuapp.com/public/{resource}"

    @dlt.resource(
            name="riders",
            primary_key="rider_id",
            #write_disposition="merge",
        )
    def get_resource():
        
        if resource=="rider":
            data = get_rider(id)
        
        if resource=="club":
            data = get_club(id)
        
        if resource=="riders":
            data = get_riders(id)

        yield from data

    pipeline = dlt.pipeline(
        pipeline_name="raw",
        destination=dlt.destinations.duckdb("data/raw.duckdb"),
        dataset_name="zwiftracing",
    )

    load_info = pipeline.run(get_resource())

    return load_info



if __name__ == "__main__":
    #print(load("rider", 4598636))
    #print(load("rider", 5574))
    #print(load("riders", [4598636, 5574, 5879996, 7252254, 5639087, 5913482, 685362, 6120611, 1240469]))
    #[12764, 161, 20650, 2707, 2740]
    print(load("club", 2740))