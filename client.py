import socketio

# Create a Socket.io client instance
sio = socketio.Client()

# Define event handlers
@sio.event
def connect():
    print('Connected to server')

@sio.event
def disconnect():
    print('Disconnected from server')

@sio.event
def chat_message(data):
    print('Message from server:', data)

# Run the client
if __name__ == '__main__':
    import time

    # Connect to the server
    sio.connect('http://192.168.0.105:5001')

    # Join a room
    room = input("Enter room name: ")
    userid = input("Enter your userid")
    sio.emit('join_room', room)

    # Send messages to the room
    while True:
        message = input("Enter your message: ")
        #arr = [message, userid, room]
        sio.emit('chat_message',message,userid,room)
        time.sleep(1)  # Delay for readability
