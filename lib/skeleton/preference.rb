module BlackStack
    module Core
        class Preference < Sequel::Model(:preference)
            many_to_one :user, :class=>:'BlackStack::Core::User', :key=>:id_user

            TYPE_STRING = 1
            TYPE_INTEGER = 2
            TYPE_FLOAT = 3
            TYPE_BOOLEAN = 4

            # return the type of parameter x
            def self.type_of(x)
                # if default is a string
                if x.is_a?(String)
                    return BlackStack::Core::Preference::TYPE_STRING
                elsif x.is_a?(Integer)
                    return BlackStack::Core::Preference::TYPE_INTEGER
                elsif x.is_a?(Float)
                    return BlackStack::Core::Preference::TYPE_FLOAT
                elsif x.is_a?(TrueClass) || default.is_a?(FalseClass)
                    return BlackStack::Core::Preference::TYPE_BOOLEAN
                else
                    return nil
                end
            end

            # get a descriptive name for a type value
            def self.type_name(type)
                if type == BlackStack::Core::Preference::TYPE_STRING
                    return "String"
                elsif type == BlackStack::Core::Preference::TYPE_INTEGER
                    return "Integer"
                elsif type == BlackStack::Core::Preference::TYPE_FLOAT
                    return "Float"
                elsif type == BlackStack::Core::Preference::TYPE_BOOLEAN
                    return "Boolean"
                else
                    return "Unknown"
                end
            end

            def set_value(x)
                # if default is a string
                if default.is_a?(String)
                    type = BlackStack::Core::Preference::TYPE_STRING
                elsif default.is_a?(Integer)
                    type = BlackStack::Core::Preference::TYPE_INTEGER
                elsif default.is_a?(Float)
                    type = BlackStack::Core::Preference::TYPE_FLOAT
                elsif default.is_a?(TrueClass) || default.is_a?(FalseClass)
                    type = BlackStack::Core::Preference::TYPE_BOOLEAN
                else
                    raise "Invalid default value for preference. Expected String, Integer, Float, or Boolean."
                end

            end

        end # class Notification
    end # module Core
end # module BlackStack