module BlackStack
    module MySaaS
        class NotificationLink < Sequel::Model(:notification_link)
            # get the tracking url for a specific user
            def tracking_url(u)
                errors = []
                # validate: u must be a user
                errors << "u must be a user" unless u.is_a?(BlackStack::MySaaS::User)
                # validation: self.id must be a valid guid
                errors << "self.id must be a valid guid" unless self.id.to_s.guid?
                # if errors, raise exception
                raise errors.join("\n") if errors.size>0
                # get the tracking url
                "#{CS_HOME_WEBSITE}/api1.0/notifications/click.json?lid=#{self.id.to_guid}&uid=#{u.id.to_guid}"
            end
        end # class NotificationLink
    end # module MySaaS
end # module BlackStack