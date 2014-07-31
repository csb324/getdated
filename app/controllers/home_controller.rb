class HomeController <ApplicationController
  def index
    if signed_in?
      potentials = current_user.potential_matches
      @users = potentials.sort_by{ |user| user.match_with(current_user)}.reverse
    end
  end
end
