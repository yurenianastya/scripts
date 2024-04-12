# This files contains your custom actions which can be used to run
# custom Python code.
#
# See this guide on how to implement these action:
# https://rasa.com/docs/rasa/custom-actions

import json
import re

from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
from typing import Any, Text, Dict, List


class ActionOrder(Action):

    def name(self) -> Text:
        return "action_order"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        return []


class ActionShowMenu(Action):

    def name(self) -> Text:
        return "action_show_menu"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        FILE_PATH = 'menu.json'
        response = "The menu:\n"

        with open(FILE_PATH, 'r') as file:
            data = json.load(file)

        items = data['items']

        for item in items:
            name = item['name']
            price = item['price']
            prep_time = item['preparation_time']
            response += f"{name}: costs {price} and its preparation time is {prep_time}\n"
        dispatcher.utter_message(text=response)
        return []


class ActionCheckHours(Action):

    def name(self) -> Text:
        return "action_check_open_hours"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        FILE_PATH = 'work_hours.json'

        with open(FILE_PATH, 'r') as file:
            data = json.load(file)

        message = tracker.latest_message.get("text")

        matches = re.findall(r'\b(?:0?1?\d|2[0-4])\b', message)
        if matches:
            user_time = int(matches[0])
        else:
            dispatcher.utter_message(text="I couldn't find a correct number in your message.")
            return []

        current_day = None

        for day in data.keys():
            if day.lower() in message.lower():
                current_day = day
                break
        if not current_day:
            dispatcher.utter_message(text="I couldn't find a day in your message.")
            return []

        if current_day in data:
            open_time = data[current_day]["open"]
            close_time = data[current_day]["close"]
            if close_time > user_time > open_time:
                response = "Yes, we are open at that time."
            else:
                response = "No, we are closed at that time."
        else:
            response = "Sorry, we do not have information for today's hours."

        dispatcher.utter_message(text=response)
        return []
