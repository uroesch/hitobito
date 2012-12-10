class ApplicationController < ActionController::Base
  
  include DecoratesBeforeRendering
  alias_method :decorate, :__decorator_for__
  
  protect_from_forgery
  helper_method :current_user, :person_home_path
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => "Sie sind nicht berechtigt, diese Seite anzuzeigen"
  end
  
  before_filter :authenticate_person!
  check_authorization :unless => :devise_controller?

  
  private

  def current_user
    current_person
  end
  
  def current_person
    @current_person ||= super.tap do |user|
      Person::PreloadGroups.for(user)
    end
  end
  
  def person_home_path(person)
    if group = person.groups.select('groups.id').first
      group_person_path(group, person)
    else
      group_path(Group.root)
    end
  end
end
