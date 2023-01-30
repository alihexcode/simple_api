# if there is no OAuth application created, create them
unless Doorkeeper::Application.any?
  Doorkeeper::Application.create([
                                   { name: 'iOS client', redirect_uri: '', scopes: '' },
                                   { name: 'Android client', redirect_uri: '', scopes: '' },
                                   { name: 'Web', redirect_uri: '', scopes: '' }
                                 ])
end
