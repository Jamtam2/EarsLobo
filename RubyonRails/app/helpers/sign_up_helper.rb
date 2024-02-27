# frozen_string_literal: true

module SignUpHelper

  # display_role: this function changes the displayed role name. If 'local_moderator' or 'global_moderator',
  # the group column will display 'Moderator'. If 'regular_user', then 'User' will be displayed in the role column.
  def display_role(role)
    case role
    when 'local_moderator'
      'Enterprise Owner'
    when 'global_moderator'
      'Deborah'
    when 'regular_user'
      'User'
    when 'location_moderator'
      'Location Moderator'
    else
      role.humanize
    end
  end

end
