import streamlit as st
import re
import duckdb

def rider_input(team):
    ids_input = st.text_area(f"Team {team} IDs", key=f"team_{team}_ids_input")
    st.session_state[f"team_{team}_ids"] = [int(x) for x in re.findall(r"-?\d+", ids_input)]
    return st.session_state[f"team_{team}_ids"]


# Frontend
st.set_page_config(page_title="ZwiftScout", page_icon=":bicycle:")

st.title("ZwiftScout")
st.markdown("*Data Driven Racing Strategy*")

c1, c2 = st.columns(2)

with c1:
    rider_input(1)

with c2:
    rider_input(2)

t_summary, t_power, t_phenotypes, t_handicaps = st.tabs(["Summary", "Power Curves", "Phenotypes", "Handicaps"])

with t_summary:
    summary_table = st.container()


# Backend
if "obt__riders" not in st.session_state:
    with duckdb.connect("data/analytics.duckdb") as con:
        st.session_state["obt__riders"] = con.sql("select * from analytics.core.obt__riders").pl()

obt__riders = st.session_state["obt__riders"]

ids = st.session_state["team_1_ids"] + st.session_state["team_2_ids"]


if len(ids)>0:
    with duckdb.connect() as con:
        selected_riders = con.sql(f"select * from obt__riders where id in ({','.join([str(i) for i in ids])})").pl()
    summary_table.dataframe(selected_riders)