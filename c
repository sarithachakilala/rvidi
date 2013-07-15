[1mdiff --git a/app/controllers/home_controller.rb b/app/controllers/home_controller.rb[m
[1mindex a1da238..c8817d0 100644[m
[1m--- a/app/controllers/home_controller.rb[m
[1m+++ b/app/controllers/home_controller.rb[m
[36m@@ -5,8 +5,7 @@[m [mclass HomeController < ApplicationController[m
     @all_shows = Show.public_shows[m
     @newest_shows =  Show.public_shows.limit(6).order('created_at desc')[m
     @most_viewed =  Show.public_shows.order('number_of_views desc')[m
[31m-  #  @most_commented = Show.public_shows.select("shows.id, count('comments.id') as comm_count").joins(:comments).group("shows.id").order("comm_count desc")[m
[31m-    # @most_commented = Comment.count(:group =>"comments.show_id", :order=> "count_all desc")[m
[32m+[m[32m    @most_commented = Show.public_shows.select("shows.id, count('comments.id') as comm_count").joins(:comments).group("shows.id").order("comm_count desc").all[m
     respond_to do |format|[m
       format.html{}[m
       format.json { render json: user }[m
[1mdiff --git a/app/controllers/sessions_controller.rb b/app/controllers/sessions_controller.rb[m
[1mindex 6d321e6..374a1c3 100644[m
[1m--- a/app/controllers/sessions_controller.rb[m
[1m+++ b/app/controllers/sessions_controller.rb[m
[36m@@ -11,7 +11,7 @@[m [mclass SessionsController < ApplicationController[m
   def create[m
     if (params[:fetch_invities].present? && params[:fetch_invities] == 'true')[m
       auth = env["omniauth.auth"][m
[31m-      session[:uid] = auth['uid'][m
[32m+[m[32m      session[:uid] = auth['uid'].to_i[m
       session[:auth_token] = auth.credentials.token[m
       session[:auth_secret] = auth.credentials.secret[m
       logger.debug session[:uid][m
[1mdiff --git a/app/controllers/shows_controller.rb b/app/controllers/shows_controller.rb[m
[1mindex b172317..e4c783b 100644[m
[1m--- a/app/controllers/shows_controller.rb[m
[1m+++ b/app/controllers/shows_controller.rb[m
[36m@@ -223,12 +223,12 @@[m [mclass ShowsController < ApplicationController[m
     @user = User.find(current_user.id)[m
     RvidiMailer.delay.invite_friend_to_show(email, current_user, show.id)[m
     InviteFriend.create(:director_id => show.user_id, :show_id => show.id,[m
[31m-                        :contributor_email => email, :status =>"invited" )[m
[32m+[m[32m      :contributor_email => email, :status =>"invited" )[m
     [m
     flash[:notice] = "Your invitation will be sent as soon as you publish the show"                 [m
     notification = Notification.new(:show_id => show.id, :from_id => current_user.id, [m
[31m-                                    :to_id => '', :status => "contribute",[m
[31m-                                    :content =>" has Requested you to contribute for their Show ", :to_email=>params[:email])[m
[32m+[m[32m      :to_id => '', :status => "contribute",[m
[32m+[m[32m      :content =>" has Requested you to contribute for their Show ", :to_email=>params[:email])[m
     notification.save![m
   end[m
 [m
[36m@@ -268,12 +268,14 @@[m [mclass ShowsController < ApplicationController[m
 [m
   def add_twitter_invities[m
     # @show = Show.find(params[:id])[m
[32m+[m[32m    @friends = User.current_user_friends(current_user)[m[41m [m
     if session[:uid].present?[m
       uid = session[:uid][m
       User.configure_twitter(session[:auth_token], session[:auth_secret])[m
       session[:uid] = session[:auth_token] = session[:auth_secret] = nil[m
       begin[m
[31m-        @twitter_friends = Twitter.followers(uid.to_i)[m
[32m+[m[32m        @twitter_friends = Twitter.followers(uid)[m
[32m+[m[32m        raise "here"[m
         redirect_to edit_show_path(params[:id])[m
       rescue[m
         flash[:alert] = 'Twitter rake limit exceeded'[m
[1mdiff --git a/app/views/friends/_facebook_users.html.erb b/app/views/friends/_facebook_users.html.erb[m
[1mindex df09c8b..644a244 100644[m
[1m--- a/app/views/friends/_facebook_users.html.erb[m
[1m+++ b/app/views/friends/_facebook_users.html.erb[m
[36m@@ -5,9 +5,12 @@[m
 <% facebook_friends.each_slice(3).each do |friends_slice| %>[m
   <div class="row-fluid margin-top-5">[m
     <% friends_slice.each do|friend| %>[m
[31m-      <div class="span4">[m
[31m-        <%= render :partial=>"friends/facebook_user", :locals=> {:friend => friend} %>[m
[31m-      </div>[m
[32m+[m[32m      <% verify_existing_user = Authentication.where(:uid => friend['id']) %>[m
[32m+[m[32m      <% unless verify_existing_user.present? %>[m
[32m+[m[32m        <div class="span4">[m
[32m+[m[32m          <%= render :partial=>"friends/facebook_user", :locals=> {:friend => friend} %>[m
[32m+[m[32m        </div>[m
[32m+[m[32m      <% end %>[m
     <% end %>[m
   </div>[m
 <% end %>[m
\ No newline at end of file[m
[1mdiff --git a/app/views/friends/_rvidi_users.html.erb b/app/views/friends/_rvidi_users.html.erb[m
[1mindex 9ece6bb..6b1fd4d 100644[m
[1m--- a/app/views/friends/_rvidi_users.html.erb[m
[1m+++ b/app/views/friends/_rvidi_users.html.erb[m
[36m@@ -1,16 +1,17 @@[m
 <% if controller.action_name!="friends" %>[m
[31m-	<label class="select-all-label checkbox inline btn btn-mini pull-right font-size-14">[m
[31m-	  Select all[m
[31m-	</label>[m
[32m+[m[32m  <label class="select-all-label checkbox inline btn btn-mini pull-right font-size-14">[m
[32m+[m[32m      Select all[m
[32m+[m[32m  </label>[m
 <% end %>[m
 <div class="cl"></div>[m
[31m-[m
[31m-<% users.each_slice(3) do|users_slice| %>[m
[31m-  <div class="row-fluid margin-top-5">[m
[31m-    <% users_slice.each do |user| %>[m
[31m-      <div class="span4">[m
[31m-        <%= render :partial => "friends/rvidi_user", :locals => {:user => user} %>[m
[31m-      </div>[m
[31m-    <% end %>[m
[31m-  </div>[m
[32m+[m[32m<% if users.present? %>[m
[32m+[m[32m  <% users.each_slice(3) do|users_slice| %>[m
[32m+[m[32m    <div class="row-fluid margin-top-5">[m
[32m+[m[32m      <% users_slice.each do |user| %>[m
[32m+[m[32m        <div class="span4">[m
[32m+[m[32m          <%= render :partial => "friends/rvidi_user", :locals => {:user => user} %>[m
[32m+[m[32m        </div>[m
[32m+[m[32m      <% end %>[m
[32m+[m[32m    </div>[m
[32m+[m[32m  <% end %>[m
 <% end %>[m
[1mdiff --git a/app/views/shows/form/_friends_block.html.erb b/app/views/shows/form/_friends_block.html.erb[m
[1mindex e3a6952..ab557c2 100644[m
[1m--- a/app/views/shows/form/_friends_block.html.erb[m
[1m+++ b/app/views/shows/form/_friends_block.html.erb[m
[36m@@ -1,23 +1,23 @@[m
 <div id="collapseThree" class="accordion-body collapse in">[m
   <div class="accordion-inner">[m
[31m-    [m
[32m+[m
     <div class="border-bottom-black"></div>[m
[31m-    [m
[32m+[m
     <div class="row-fluid margin-bottom-10">[m
       <div class="title"> Invite some friends to contribute to this show!</div>[m
     </div>[m
[31m-    [m
[32m+[m
     <div class="row-fluid margin-bottom-20">[m
[31m-      [m
[32m+[m
       <!-- Show LinkedIn Facebook Buttons -->[m
       <div class="span6" > [m
         <% unless params[:controller] =="shows" && params[:action] == "new" %>[m
[31m-          <%= link_to raw("<i class=\"sprite-facebook-white \"></i>Add from Facebook"), [m
[31m-                '#', :class => "btn  btn-primary add_from_facebook" %>[m
[32m+[m[32m          <%= link_to raw("<i class=\"sprite-facebook-white \"></i>Add from Facebook"),[m
[32m+[m[32m            '#', :class => "btn  btn-primary add_from_facebook" %>[m
           <%= link_to raw("<i class=\"sprite-facebook-white \"></i>Add from twitter"), "/auth/twitter?fetch_invities=true&show_id=#{params[:id]}", :class=>"btn btn-info" %>[m
         <% end %>[m
       </div>[m
[31m-    [m
[32m+[m
       <!-- Show Search rVidi Users Buttons -->[m
       <div class="span6">[m
         <div class="input-append pull-right">[m
[36m@@ -28,20 +28,22 @@[m
           </div>[m
         </div>[m
       </div>[m
[31m-      [m
[32m+[m
     </div>[m
[31m-    [m
[32m+[m
     <div class="border-bottom-black"></div>[m
[31m-    [m
[32m+[m
     <div id="div_show_friends" class="margin-bottom-10 selects-container">[m
       <%= render :partial=>"friends/friend_mappings", :locals=> {:friend_mappings=>@friend_mappings} %>[m
     </div>[m
[31m-    [m
[32m+[m
     <div class="">[m
       <% if @twitter_friends.present? %>[m
[31m-        <%= render :partial=>"twitter_friends_list"%>[m
[32m+[m[32m        <%= render :partial=>'friends/twitter_users'%>[m
       <% end %>[m
     </div>[m
[31m-    [m
[32m+[m[32m    <div id="div_show_friends" class="margin-bottom-10 selects-container">[m
[32m+[m[32m      <%= twitter_friends_or_existing_friends(@friends, @twitter_friends) %>[m
[32m+[m[32m    </div>[m
   </div>[m
 </div>[m
\ No newline at end of file[m
