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


""" This class defines a C-like struct """
class Payload(Structure):
    _fields_ = [("id", c_uint32),
                ("counter", c_uint32),
                ("temp", c_float)]

HOST = '0.0.0.0'
PORT = 1234
RECV = 'NULL'

app = dash.Dash(__name__)

app.layout = html.Div([

    html.Button('Connect', id='connect-button', n_clicks=0),

    html.Div(children=[
        dcc.Textarea(
            id='textarea-example',
            value=RECV,
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
    [Input('connect-button', component_property='n_clicks')]
)
def connect_to_chaos(n_clicks):
    if n_clicks > 0:
        connected = False

        server_addr = ('localhost', 1234)
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        try:
            s.connect(server_addr)
            print("Connected to {:s}".format(repr(server_addr)))
            connected = True

            for i in range(5):
                print("")
                payload_out = Payload(1, i, random.uniform(-10, 30))
                print("Sending id={:d}, counter={:d}, temp={:f}".format(payload_out.id,
                                                                payload_out.counter,
                                                                payload_out.temp))
                nsent = s.send(payload_out)
                # Alternative: s.sendall(...): coontinues to send data until either
                # all data has been sent or an error occurs. No return value.
                print("Sent {:d} bytes".format(nsent))

                buff = s.recv(sizeof(Payload))
                payload_in = Payload.from_buffer_copy(buff)
                print("Received id={:d}, counter={:d}, temp={:f}".format(payload_in.id,
                                                                payload_in.counter,
                                                                payload_in.temp))
        except AttributeError as ae:
            print("Error creating the socket: {}".format(ae))
        except socket.error as se:
            print("Exception on socket: {}".format(se))
        finally:
            print("Closing socket")
            s.close()

        if connected:
            return {'width': '100%', 'height': 300, 'display': 'block'}
        else:
            return {'width': '100%', 'height': 300, 'display': 'none'}
    
    return {'width': '100%', 'height': 300, 'display': 'none'}

# @app.route('/')
# def hello_world():
#     return "Docker container is up and running!"

# @app.route('/commandChaos')
# def command_chaos():
#     value = request.args.get('command')
#     return "Received command: " + value

if __name__ == '__main__':
    app.run_server(debug=True, host='0.0.0.0', port=5000)