class My::Doctors::WalletsController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }, except: []
end
