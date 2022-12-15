# 67443-App
An iOS app created for 67-443 Mobile Application Development at CMU by Scott King, Shayan Panjwani, and Ahsan Rasool <br>

In order for app to function, you will need to get the GoogleService-Info.plist from Team 20's 
slack channel and put it in `/Songbird/Configs/`. You will also need to be added to the whitelist 
for our Spotify Web API app, which will require an email associated with a Spotify Premium Account 
(ping Scott on Slack in Team 20's channel). <br>

Playlists created with Spotify's web API can take a few minutes to become 
visible in the Spotify App or web player, even though they have been created. This lag is purely 
on Spotify's end. Force quitting the Spotify app and reopening it will make it pull newly 
created playlists from the server. <br>

To better test out the calendar feature, ping Scott and Shayan in our slack channel so that we can add some fake songs
to your history in firebase as though you had chosen a song on those days. <br>

### Attributions
- Built with SpotifyAPI by Peter Schorn (https://github.com/Peter-Schorn/SpotifyAPI)
- Based on this example app by Peter Schorn (https://github.com/Peter-Schorn/SpotifyAPI)
- Uses KeychainAccess by kishikawakatsumi (https://github.com/kishikawakatsumi/KeychainAccess)
- Calendar functionality implemented with ElegantCalendar by ThasianX (https://github.com/ThasianX/ElegantCalendar)
- Date handling implemented with SwiftDate by malcommac (https://github.com/malcommac/SwiftDate)

### Use Cases
- Users get recommendations for songs to pick for the day.
  - Able to see multiple recommended songs
  - Able to choose between multiple methods of song recommendation
  - Able to select a song from recommendations
- Users can see songs they selected for previous days.
  - Able to see which days they chose a song in a calendar view
  - Able to see song picked on a certain day if exists
- User can log in and out of different Spotify accounts, which are tied to Songbird accounts
  - Able to switch log out of connected Spotify account
  - Able to log into Spotify account
  - Songbird specific data tied to Spotify accounts
- Users can create playlists for custom intervals made from their song choices of that period
  - Select the start and end date on the calendar to create a playlist.
  - Able to export playlist to Spotify if songs exist in the range

