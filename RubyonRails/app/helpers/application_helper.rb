module ApplicationHelper
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
end