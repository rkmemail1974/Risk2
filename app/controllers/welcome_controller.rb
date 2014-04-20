
class WelcomeController < WebsocketRails::BaseController
    include ActionView::Helpers::SanitizeHelper
    
    def initialize_session
        puts "Session Initialized\n"
    end
    
    def system_msg(ev, msg)
        broadcast_message ev, {
            user_name: 'system',
            received: Time.now.to_s(:short),
            msg_body: msg
        }
    end
    
    def user_msg(ev, msg)
        broadcast_message ev, {
            user_name:  connection_store[:user][:user_name],
            received:   Time.now.to_s(:short),
            msg_body:   ERB::Util.html_escape(msg)
        }
    end
    
    def new
        new_mess = {:user_name => 'this is a test of new function', msg_body: "hello", new_field: 'new data'}
        broadcast_message :newMess, new_mess 
    
    end
    
    def newer
        country = {:user_name => "america", msg_body: "japan", new_field: 'new data'}
        broadcast_message :country, country
    end
    
    def green_message
        greenMess = {:user_name => 'testing green', msg_body: 'green', new_field: 'new data'}
        broadcast_message :greenMess, greenMess
    end
    
    def blue_message
        blueMess = {:user_name => 'testing blue', msg_body: 'blue', new_field: 'new data'}
        broadcast_message :blueMess, blueMess
    end
    
    def client_connected
        system_msg :new_message, "client #{client_id} connected"
    end
    
    def new_message
        user_msg :new_message, message[:msg_body].dup
    end
    
    def new_user
        connection_store[:user] = { user_name: sanitize(message[:user_name]) }
        broadcast_user_list
    end
    
    def change_username
        connection_store[:user][:user_name] = sanitize(message[:user_name])
        broadcast_user_list
    end
    
    def delete_user
        connection_store[:user] = nil
        system_msg "client #{client_id} disconnected"
        broadcast_user_list
    end
    
    def broadcast_user_list
        users = connection_store.collect_all(:user)
        broadcast_message :user_list, users
    end
    
end
