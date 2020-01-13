import consumer from "./consumer"
console.log('hello')
window.onload = function () {
  const chatChannel = consumer.subscriptions.create({ channel: 'RoomChannel', room: document.getElementById('kpt').getAttribute('data-room_id') }, {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      return document.getElementById("kpt").insertAdjacentHTML("beforeend", data['message']);
    },

    speak: function(message) {
      return this.perform('speak', {
        message: message
      });
    }
  });

  document.getElementById("content").addEventListener('keypress',function(){
    if (event.keyCode === 13) {
      chatChannel.speak(event.target.value);
      event.target.value = '';
      return event.preventDefault();
    }
  });
}
