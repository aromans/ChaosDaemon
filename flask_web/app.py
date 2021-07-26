import dash
import dash_html_components as html
import dash_core_components as dcc
from dash.dependencies import Input, Output, State

from flask import Flask, request
from flask.wrappers import Request

import socket
import sys
import random
from ctypes import *

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
print('socket created')
PORT = 11000
IP_ADDR = '0.0.0.0'


app = dash.Dash(__name__)

app.layout = html.Div([

    html.Button('Connect', id='connect-button', n_clicks=0),

    html.Div(id='textarea-example-output', style={'whiteSpace': 'pre-line'}),

    html.Div(children=[
        dcc.Textarea(
            id='textarea-example',
            value="",
            style={'width': '100%', 'height': 300, 'display': 'none'},
        ),
        # html.Button('Submit', id='textarea-state-example-button', n_clicks=0),
    ])
])

# @app.callback(
#     Output('textarea-state-example-output', 'children'),
#     Input('textarea-state-example', 'value')
# )
# def update_chaos_server(value):
#     return value

@app.callback(
    Output('textarea-example', component_property='style'),
    Output('textarea-example-output', 'children'),
    Input('connect-button', component_property='n_clicks')
)
def connect_to_chaos(n_clicks):
    status = "Normal"

    if n_clicks > 0:

        connected = s.connect((IP_ADDR, PORT))

        status += " maybe"

        if connected:
            return {'width': '100%', 'height': 300, 'display': 'block'}, status
        else:
            return {'width': '100%', 'height': 300, 'display': 'none'}, status

        # connected = False

        # status += " n_click"

        # server_addr = ('0.0.0.0', 11000)

        # with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        #     try:
        #         s.connect(server_addr)
        #         status += " Connected to {:s}".format(repr(server_addr))
        #         connected = True
        #     except AttributeError as ae:
        #         status += " Error creating the socket: {}".format(ae)
        #     except socket.error as se:
        #         status += " Exception on socket: {}".format(se)
        #     finally:
        #         status += " Closing socket"
        #         s.close()
    
    return {'width': '100%', 'height': 300, 'display': 'none'}, status

# @app.route('/')
# def hello_world():
#     return "Docker container is up and running!"

# @app.route('/commandChaos')
# def command_chaos():
#     value = request.args.get('command')
#     return "Received command: " + value

if __name__ == '__main__':
    app.run_server(debug=True, host='0.0.0.0', port=5000)