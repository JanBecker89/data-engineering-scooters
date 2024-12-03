import functions_framework
import pandas as pd
import requests
import sqlalchemy
from pytz import timezone
from datetime import datetime
from keys import GCP_pass
from keys import OW_API_key

@functions_framework.http
def weather_update(request):
    schema = "gans_cloud" # The name of your database
    host = "35.195.104.153"
    user = "root"
    password = GCP_pass # Your MySQL password
    port = 3306

    connection_string = f'mysql+pymysql://{user}:{password}@{host}:{port}/{schema}'
    
    cities_from_df_2 = pd.read_sql("cities", con=connection_string)
    API_key = OW_API_key
    
    weather_list_2 = []
    berlin_timezone = timezone('Europe/Berlin')

    for city in cities_from_df_2["City_name"]:
        weather_2 = requests.get(f"http://api.openweathermap.org/data/2.5/forecast?q={city}&appid={API_key}&units=metric")
        weather_json_2 = weather_2.json()

        city_id = cities_from_df_2.loc[cities_from_df_2["City_name"]== city, "City_id"].values[0]
        retrieval_time = datetime.now(berlin_timezone).strftime("%Y-%m-%d %H:%M:%S")

        for item in weather_json_2["list"]:
            weather_dict_2 = {
            "city_id": city_id,
            "forecast_time": item.get("dt_txt", None),
            "outlook": item["weather"][0].get("description", None),
            "temperature": item["main"].get("temp", None),
            "feels_like": item["main"].get("feels_like", None),
            "rain_in_last_3h": item.get("rain", {}).get("3h", 0),
            "wind_speed": item["wind"].get("speed", None),
            "rain_prob": item.get("pop", None),
            "data_retrieved_at": retrieval_time}

            weather_list_2.append(weather_dict_2)
            
    weather_to_db_2 = pd.DataFrame(weather_list_2)
    weather_to_db_2["forecast_time"] = pd.to_datetime(weather_to_db_2["forecast_time"])
    weather_to_db_2.to_sql('weather',
                  if_exists='append',
                  con=connection_string,
                  index=False)
    
    return "Success"
