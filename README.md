# etherpad-lite-heroku

Runs etherpad-lite on Heroku with no modifications to the etherpad-lite source. Contains the
etherpad-lite source as a subtree.

## Getting started

1. Provision a Heroku Cedar app.
2. Populate Heroku config with least ```DATABASE_URL``` and ```ETHERPAD_API_KEY```.
   Currently, only MySQL is supported out of the box, but this is overridable (see
   [extras](#extras)).
3. Push to Heroku.

Easy as pie.

## Extras

* Want to install some etherpad-lite plugins? Just add the plugin names
  (without the ```ep_``` prefix) to the ```ETHERPAD_PLUGINS``` config variable as a
  comma-separated list and they'll install on app restart.
* Want to override some of the default configuration? Provide a JSON object in the
  ```ETHERPAD_SETTINGS``` config variable. Those settings will be merged into the configuration.

AWESOME!
