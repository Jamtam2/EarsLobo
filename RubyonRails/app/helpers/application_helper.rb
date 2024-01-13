module ApplicationHelper
    require 'csv'
    def flash_message(flash_type)
        case flash_type
        when 'notice' then 'success'
        when 'alert'  then 'danger'
        else flash_type.to_s
        end
    end

    def active_class(path)
        if request.path == path
            return 'active'
        else
            return ''
        end
    end

    def generate_user_data_csv(user)
        CSV.generate(headers: true) do |csv|
            csv << ['p']

            user.data_each do |data_item|
                csv << [data_item.attribute, data_item.attribute2]
            end
        end
    end
end
