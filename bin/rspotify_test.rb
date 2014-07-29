
require 'RSpotify'
require 'pry'

class RSpotifyTest

  RSpotify.authenticate('eecc0f357b2945738b58d478651f5a9a', 'e954393e502f4018b01b5b09a77b69d6')

# Now you can access any public playlist and much more

  playlist = RSpotify::Playlist.find('wizzler', '00wHcTN0zQiun4xri9pmvX')
  playlist.name               #=> "Movie Soundtrack Masterpieces"
  playlist.description        #=> "Iconic soundtracks featured..."
  playlist.followers['total'] #=> 13
  playlist.tracks             #=> (Track array)

  my_user = RSpotify::User.find('bizarre_bzr')
  binding.pry
  my_playlists = my_user.playlists #=> (Playlist array)
  puts my_playlists

end
