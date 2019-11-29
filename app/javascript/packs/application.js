require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

var componentRequireContext = require.context("components", true);
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);

function myClick(splint) {
    var obj = JSON.parse(splint);
    console.log(obj)
}
