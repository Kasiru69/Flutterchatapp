import socketio
import socket

# Create a Socket.io server instance
sio = socketio.Server(cors_allowed_origins='*')
app = socketio.WSGIApp(sio)
host_address = socket.gethostbyname(socket.gethostname())
print('Server IP address:', host_address)
map={}
# Store client IDs
clients = set()

# Define event handlers
@sio.event
def connect(sid, environ):
    print('Connected', sid)
    clients.add(sid)

@sio.event
def join_room(sid, room):
    sio.enter_room(sid, room)
    print(sid, 'joined room', room)

@sio.event
def chat_message(sid, data1,data2,data3):
    data=[data1,data2,data3]
    print("hello",type(data1))
    #room = list(sio.rooms(sid))[1]  # Get the room SID is in
    arr=[data[0],data[1],data[2]]
    if data[2] not in map:
        map[data[2]]=[]
    map[data[2]].append(arr)
    print(map)
    sio.emit('chat_message', data)

@sio.event
def disconnect(sid):
    print('Disconnected', sid)
    clients.remove(sid)

# Run the server
if __name__ == '__main__':
    import eventlet
    import eventlet.wsgi

    # Use eventlet to run multiple clients concurrently
    port = 5001
    eventlet.wsgi.server(eventlet.listen(('192.168.0.105', port)), app)
