from flask import Flask, render_template, request, redirect, url_for
import pandas as pd
import requests
import json


app = Flask(__name__)


def get_data(dt):
    return requests.get(
        f"https://statsapi.mlb.com/api/v1/schedule?startDate={dt}&endDate={dt}&sportId=1"
    ).json()


def determine_winner_loser(game, who):
    if game["teams"][who]["isWinner"]:
        return game["teams"][who]["team"]["name"] + " ----- " + "(W)"
    else:
        return game["teams"][who]["team"]["name"]


@app.route("/schedule/<dt>")
def parse_data(dt):
    data = get_data(dt)
    games = []
    for date in data["dates"]:
        for game in date["games"]:
            game_info = {
                "home_team": determine_winner_loser(game, "home"),
                "home_team_record": str(game["teams"]["home"]["leagueRecord"]["wins"])
                + "-"
                + str(game["teams"]["home"]["leagueRecord"]["losses"]),
                "away_team": determine_winner_loser(game, "away"),
                "away_team_record": str(game["teams"]["away"]["leagueRecord"]["wins"])
                + "-"
                + str(game["teams"]["away"]["leagueRecord"]["losses"]),
                "Home v Away Score": str(game["teams"]["home"]["score"])
                + "-"
                + str(game["teams"]["away"]["score"]),
            }

            games.append(game_info)
    df = pd.DataFrame(games)

    # Convert DataFrame to HTML table
    table = df.to_html(classes="table table-striped", index=False)
    return render_template("schedule.html", table=table)


@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        dt = request.form["dt"]
        return redirect(url_for("parse_data", dt=dt))
    return render_template("index.html", table="")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)
