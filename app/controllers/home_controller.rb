class HomeController < ApplicationController
  def index
    if user_signed_in?
      # gets potentials based on gender and interest and location
      potentials = current_user.potential_matches
      @users = potentials.sort_by{ |user| user.match_with(current_user)}.reverse
    end
  end
end
