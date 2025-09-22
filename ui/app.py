import streamlit as st
import re
import duckdb


# Take user input of a string containing IDs and return a list of integers
def rider_input(team, default):
    ids_input = st.text_area(f"Team {team} IDs", key=f"team_{team}_ids_input",value=default)
    ids = [int(x) for x in re.findall(r"-?\d+", ids_input)]
    return ids


# Take two lists of int IDs, filter obt__riders table and return with team number
def get_selected_riders(team_1_ids, team_2_ids):

    ids = team_1_ids + team_2_ids
    
    if len(ids)>0:
        with duckdb.connect() as con:
            selected_riders = con.sql(f"""
                                    with team_1 as (
                                        select 1 as team, *
                                        from obt__riders
                                        where id in ({','.join([str(i) for i in team_1_ids+[0]])})
                                    ),

                                    team_2 as (
                                        select 2 as team, * 
                                        from obt__riders
                                        where id in ({','.join([str(i) for i in team_2_ids+[0]])})
                                    )

                                    (select * from team_1) union all (select * from team_2)
                                    """).pl()
        
        return selected_riders




# Frontend
st.set_page_config(page_title="ZwiftScout", page_icon=":bicycle:")

st.title("ZwiftScout")
st.markdown("*Data Driven Racing Strategy*")

c1, c2 = st.columns(2)

with c1:
    team_1_ids = rider_input(1, "5879996,6120611,5913482,5859202,2715883")

with c2:
    team_2_ids = rider_input(2, "4598636,5993288,5556489,5026980,5067167")

t_summary, t_power, t_phenotypes, t_handicaps = st.tabs(["Summary", "Power Curves", "Phenotypes", "Handicaps"])

with t_summary:
    summary_table = st.container()


# Backend
if "obt__riders" not in st.session_state:
    with duckdb.connect("data/analytics.duckdb") as con:
        st.session_state["obt__riders"] = con.sql("select * from analytics.core.obt__riders").pl()

obt__riders = st.session_state["obt__riders"]



    
selected_riders = get_selected_riders(team_1_ids, team_2_ids)

summary_table.dataframe(selected_riders)