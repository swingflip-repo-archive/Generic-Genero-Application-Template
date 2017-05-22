################################################################################
#START OF APPLICATION
#Written by Ryan Hamlin - 2017. (Ryan@ryanhamlin.co.uk)
################################################################################
IMPORT os
IMPORT util
GLOBALS "globals.4gl"

		DEFINE #These are very useful module variables to have defined!
				TERMINATE SMALLINT,
				m_string_buffer base.StringBuffer,
				m_string_tokenizer base.StringTokenizer,
				m_window ui.Window,
				m_form ui.Form,
				m_dom_node1 om.DomNode,
				m_index INTEGER,
				m_ok SMALLINT,
				m_instruction STRING
				
		DEFINE
				m_title STRING,
				m_info RECORD
						deployment_type STRING,
						os_type STRING,
						ip STRING,
						device_name STRING,
						resolution STRING,
						resolution_x STRING,
						resolution_y STRING,
						geo_status STRING,
						geo_lat STRING,
						geo_lon STRING
				END RECORD,
				m_username STRING,
				m_password STRING,
				m_remember STRING
		
MAIN

#******************************************************************************#
#Set global application details here...

		LET g_application_title = "Genero Generic Application Template"
		LET g_application_version = "v0.5 Alpha"
		LET m_title =  g_application_title || " " || g_application_version
		
#******************************************************************************#

		# RUN "set > /tmp/mobile.env" # Dump the environment for debugging.
		#BREAKPOINT #Uncomment to step through application
    DISPLAY "\nStarting up " || g_application_title || " " || g_application_version || "...\n"

		#Grab deployment data...

		CALL ui.Interface.frontCall("standard", "feInfo", "feName", m_info.deployment_type)
		CALL ui.Interface.frontCall("standard", "feInfo", "osType", m_info.os_type)
		CALL ui.Interface.frontCall("standard", "feInfo", "ip", m_info.ip)
		CALL ui.Interface.frontCall("standard", "feInfo", "deviceId", m_info.device_name)		
		CALL ui.Interface.frontCall("standard", "feInfo", "screenResolution", m_info.resolution)

		#Uncomment the below to display device data when running.
		
		IF m_info.deployment_type <> "GMA" AND m_info.deployment_type <> "GMI"
		THEN
				{DISPLAY "--Deployment Data--\n" ||
								"Deployment Type: " || m_info.deployment_type || "\n" ||
								"OS Type: " || m_info.os_type || "\n" ||
								"Device IP: " || m_info.ip || "\n" ||
								"Resolution: " || m_info.resolution || "\n" ||
								"-------------------\n"}
		ELSE
				{DISPLAY "--Deployment Data--\n" ||
								"Deployment Type: " || m_info.deployment_type || "\n" ||
								"OS Type: " || m_info.os_type || "\n" ||
								"Device IP: " || m_info.ip || "\n" ||
								"Device ID: " || m_info.device_name || "\n" ||
								"Resolution: " || m_info.resolution || "\n" ||
								"-------------------\n"}
		END IF

		IF m_info.deployment_type = "GMI"
		THEN
				CALL os.Path.copy(os.path.join(base.Application.getProgramDir(),"local_db.db"),os.Path.pwd())
				RETURNING m_ok

				DISPLAY m_ok
		END IF
		
		LET m_string_tokenizer = base.StringTokenizer.create(m_info.resolution,"x")

		WHILE m_string_tokenizer.hasMoreTokens()
				IF m_index = 1
				THEN
						LET m_info.resolution_x = m_string_tokenizer.nextToken() || "px"
				ELSE
						LET m_info.resolution_y = m_string_tokenizer.nextToken() || "px"
				END IF
				LET m_index = m_index + 1
		END WHILE

#******************************************************************************#
# HERE IS WHERE YOU CONFIGURE GOBAL SWITCHES FOR THE APPLICATION
# ADJUST THESE AS YOU SEEM FIT. BELOW IS A LIST OF OPTIONS IN ORDER:
#				g_splash_width STRING, 								#Login menu splash width when not in mobile
#				g_splash_height STRING, 							#Login menu splash height when not in mobile
#				g_enable_geolocation SMALLINT,				#Toggle to enable geolocation
#				g_enable_mobile_title SMALLINT, 			#Toggle application title on mobile
#				g_local_stat_limit INTEGER,						#Number of max local stat records before pruning
#				g_online_ping_URL STRING,							#URL of public site to test internet connectivity (i.e. http://www.google.com) 
#				g_enable_timed_connect SMALLINT,			#Enable timed connectivity checks
#				g_timed_checks_time INTEGER						#Time in seconds before checking connectivity (g_enable_timed_connect has to be enabled)
#				g_image_dest STRING										#Webserver destination for image payloads. i.e. "Webservice_1" (Not used as of yet)
#				g_enable_timed_image_upload SMALLINT,	#Enable timed image queue uploads (Could have a performance impact!)
# Here are globals not included in initialize_globals function due to sheer size of the arguement data...
#				g_client_key STRING,									#Unique Client key for webservice purposes

		CALL initialize_globals("500px","281px",FALSE,FALSE,100,"http://www.google.com",
														TRUE,10,"%d/%m/%Y %H:%M","webserver1",TRUE) #function_lib *IMPORTANT*
				RETURNING m_ok
				
		LET g_client_key = "znbi58mCGZXSBNkJ5GouFuKPLqByReHvtrGj7aXXuJmHGFr89Xp7uCqDcVCv"
				
#******************************************************************************#

		IF m_ok = FALSE
		THEN
				 CALL fgl_winmessage(m_title, "ERROR 1001:\nFailed to Initialise Global Variables.", "stop")
				 EXIT PROGRAM 1001
		END IF

		IF g_enable_geolocation = TRUE
		THEN
				IF m_info.deployment_type <> "GMA" AND m_info.deployment_type <> "GMI"
				THEN
						DISPLAY "****************************************************************************************\n" ||
										"WARNING: Set up error, track geolocation is enabled and you are not deploying in mobile.\n" ||
										"****************************************************************************************\n"
				ELSE
						CALL ui.Interface.frontCall("mobile", "getGeolocation", [], [m_info.geo_status, m_info.geo_lat, m_info.geo_lon])
						DISPLAY "--Geolocation Tracking Enabled!--"
						DISPLAY "Geolocation Tracking Status: " || m_info.geo_status
						IF m_info.geo_status = "ok"
						THEN
								DISPLAY "Latitude: " || m_info.geo_lat
								DISPLAY "Longitude: " || m_info.geo_lon
						END IF
						DISPLAY "---------------------------------\n"
				END IF
		END IF

		CALL test_connectivity(m_info.deployment_type)

		CLOSE WINDOW SCREEN #Just incase
		
#We are now initialised, we now just need to run each individual window functions...
		CALL login_screen() 

END MAIN

################################################################################



################################################################################
#Individual window/form functions...
################################################################################

FUNCTION login_screen() #Local login handler

		IF m_info.deployment_type = "Genero Desktop Client"
		THEN
				OPEN WINDOW w WITH FORM "main_gdc" ATTRIBUTE (STYLE="main")
		ELSE
				OPEN WINDOW w WITH FORM "main" ATTRIBUTE (STYLE="main")
		END IF
		
		#Initialize window specific variables
	
    LET TERMINATE = FALSE
		INITIALIZE m_instruction TO NULL
		LET m_window = ui.Window.getCurrent()
		LET m_dom_node1 = m_window.findNode("Image","splash")

		IF m_info.deployment_type <> "GMA" AND m_info.deployment_type <> "GMI"
		THEN
				CALL m_window.setText(m_title)
		ELSE
				IF g_enable_mobile_title = FALSE
				THEN
						CALL m_window.setText("")
				ELSE
						CALL m_window.setText(m_title)
				END IF
		END IF

		#Set the login splash size if we are not in mobile
		IF m_info.deployment_type <> "GMA" AND m_info.deployment_type <> "GMI"
		THEN
				CALL m_dom_node1.setAttribute("sizePolicy","dynamic")
				CALL m_dom_node1.setAttribute("width",g_splash_width)
				CALL m_dom_node1.setAttribute("height",g_splash_height)
		END IF

		INPUT m_username, m_password, m_remember FROM username, password, remember ATTRIBUTE(UNBUFFERED)

				ON TIMER g_timed_checks_time
						CALL connection_test()
						CALL timed_upload_queue_data()
				
				BEFORE INPUT
						CALL connection_test()
						CALL capture_local_stats(m_info.*)
								RETURNING m_ok
						LET m_form = m_window.getForm()
						CALL DIALOG.setActionHidden("accept",1)
						CALL DIALOG.setActionHidden("cancel",1)
						CALL get_local_remember()
								RETURNING m_ok, m_remember, m_username

				ON CHANGE username
						LET m_username = downshift(m_username)
						CALL refresh_local_remember(m_username, m_remember)
								RETURNING m_ok

				ON CHANGE remember
						CALL refresh_local_remember(m_username, m_remember)
								RETURNING m_ok

				ON CHANGE password
						CALL refresh_local_remember(m_username, m_remember)

						RETURNING m_ok

				ON ACTION bt_login
						ACCEPT INPUT

				ON ACTION CLOSE
						EXIT INPUT
						
				AFTER INPUT
				
					CALL check_password(m_username,m_password) RETURNING m_ok
					INITIALIZE m_password TO NULL #Clean down the plain text password
					
					IF m_ok = TRUE
					THEN
							LET m_instruction = "connection"
							EXIT INPUT
					ELSE
							CALL fgl_winmessage(" ","Incorrect Username or Password", "information")
							NEXT FIELD password
					END IF
						
		END INPUT

		CASE m_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
				WHEN "connection"
						CLOSE WINDOW w
						CALL open_application()
				OTHERWISE
						CALL ui.Interface.refresh()
						CALL close_app()
		END CASE
END FUNCTION
#
#
#
#
FUNCTION open_application() #First Screen (Demo purposes is an about page)

		IF m_info.deployment_type = "Genero Desktop Client"
		THEN
				OPEN WINDOW w WITH FORM "connection_gdc" ATTRIBUTE (STYLE="main")
		ELSE
				OPEN WINDOW w WITH FORM "connection" ATTRIBUTE (STYLE="main")
		END IF
		
		LET TERMINATE = FALSE
		INITIALIZE m_instruction TO NULL
		LET m_window = ui.Window.getCurrent()

		IF m_info.deployment_type <> "GMA" AND m_info.deployment_type <> "GMI"
		THEN
				CALL m_window.setText(m_title)
		ELSE
				IF g_enable_mobile_title = FALSE
				THEN
						CALL m_window.setText("")
				ELSE
						CALL m_window.setText(m_title)
				END IF
		END IF

		LET TERMINATE = FALSE

		WHILE TERMINATE = FALSE
				MENU
				
						ON TIMER g_timed_checks_time
								CALL connection_test()
								CALL timed_upload_queue_data()
								CALL update_connection_image("splash")
								
						BEFORE MENU
								CALL connection_test()
								CALL update_connection_image("splash")
								CALL generate_about()
								DISPLAY g_application_about TO status
								IF g_user_type = "ADMIN"
								THEN
										LET m_form = m_window.getForm() #Just to be consistent
										CALL m_form.setElementHidden("bt_admint",0)
								END IF
								IF m_info.deployment_type = "GMA" OR m_info.deployment_type = "GMI"
								THEN
										LET m_form = m_window.getForm() #Just to be consistent
										CALL m_form.setElementHidden("bt_photo",0) #Photo uploads exclusive to mobile
								END IF
						ON ACTION CLOSE
								LET TERMINATE = TRUE
								EXIT MENU
						ON ACTION bt_photo
								LET m_instruction = "bt_photo"
								LET TERMINATE = TRUE
								EXIT MENU
						ON ACTION bt_sync
								CALL upload_image_payload(FALSE)
						ON ACTION bt_admint
								LET m_instruction = "admint"
								LET TERMINATE = TRUE
								EXIT MENU
						ON ACTION bt_logout
								LET m_instruction = "logout"
								LET TERMINATE = TRUE
								EXIT MENU								
							
				END MENU
		END WHILE

		CASE m_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
				WHEN "bt_photo"
						CLOSE WINDOW w
						CALL image_program()
				WHEN "admint"
						CLOSE WINDOW w
						CALL admin_tools()
				WHEN "logout"
						INITIALIZE g_user TO NULL
						INITIALIZE g_logged_in TO NULL
						DISPLAY "Logged out successfully!"
						CLOSE WINDOW w
						CALL login_screen()
				OTHERWISE
						CALL ui.Interface.refresh()
						CALL close_app()
		END CASE

END FUNCTION
#
#
#
#
FUNCTION admin_tools() #Development tools to showcase an admin login

		DEFINE
				f_words STRING

		IF m_info.deployment_type = "Genero Desktop Client"
		THEN
				OPEN WINDOW w WITH FORM "admin_gdc" ATTRIBUTE (STYLE="main")
		ELSE
				OPEN WINDOW w WITH FORM "admin" ATTRIBUTE (STYLE="main")
		END IF

		LET TERMINATE = FALSE
		INITIALIZE m_instruction TO NULL
		LET m_window = ui.Window.getCurrent()

		IF m_info.deployment_type <> "GMA" AND m_info.deployment_type <> "GMI"
		THEN
				CALL m_window.setText(m_title)
		ELSE
				IF g_enable_mobile_title = FALSE
				THEN
						CALL m_window.setText("")
				ELSE
						CALL m_window.setText(m_title)
				END IF
		END IF

		LET TERMINATE = FALSE

		WHILE TERMINATE = FALSE
				MENU
				
						ON TIMER g_timed_checks_time
								CALL connection_test()
								CALL timed_upload_queue_data()
								
						BEFORE MENU
								CALL connection_test()
								LET f_words = "These are a selection of \"VERY\" basic development tools which should be run in the gdc." || "\n\n" ||
															"These functions have no input validating so should only be used for testing purposes only! It WILL crash the app if you don't use them properly..." || "\n\n" ||
															"This section's main purpose is to showcase an 'admin only section' within the application."
								DISPLAY f_words TO words
								IF g_user_type != "ADMIN"
								THEN
										CALL fgl_winmessage("Error!", "You have tried to access an area you shouldn't...Logging out!", "stop")
										LET m_instruction = "logout"
										LET TERMINATE = TRUE
										EXIT MENU			
								END IF
								
						ON ACTION CLOSE
								LET TERMINATE = TRUE
								EXIT MENU
						ON ACTION bt_create
								LET m_instruction = "bt_create"
								LET TERMINATE = TRUE
								EXIT MENU
						ON ACTION bt_check
								LET m_instruction = "bt_check"
								LET TERMINATE = TRUE
								EXIT MENU
						ON ACTION bt_hash
								LET m_instruction = "bt_hash"
								LET TERMINATE = TRUE
								EXIT MENU
						ON ACTION bt_go_back
								LET m_instruction = "go_back"
								LET TERMINATE = TRUE
								EXIT MENU								
							
				END MENU
		END WHILE

		CASE m_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
				WHEN "bt_create"
						RUN "fglrun ../dbbin/CreateUser.42r"
				WHEN "bt_check"
						RUN "fglrun ../dbbin/CheckPassword.42r"
				WHEN "bt_hash"
						RUN "fglrun ../dbbin/HashGenerator.42r"
				WHEN "go_back"
						CLOSE WINDOW w
						CALL open_application()
				WHEN "logout"
						INITIALIZE g_user TO NULL
						INITIALIZE g_logged_in TO NULL
						DISPLAY "Logged out successfully!"
						CLOSE WINDOW w
						CALL login_screen()
				OTHERWISE
						CALL ui.Interface.refresh()
						CALL close_app()
		END CASE

END FUNCTION
#
#
#
#
FUNCTION image_program()

		DEFINE
				f_words STRING,
				f_temp_img_queue DYNAMIC ARRAY OF STRING,
				f_index INTEGER,
				f_queue_count INTEGER,
				f_payload STRING,
				f_count INTEGER

		OPEN WINDOW w WITH FORM "photo" ATTRIBUTE (STYLE="main")

		LET TERMINATE = FALSE
		INITIALIZE m_instruction TO NULL
		LET m_window = ui.Window.getCurrent()

		IF m_info.deployment_type <> "GMA" AND m_info.deployment_type <> "GMI"
		THEN
				CALL m_window.setText(m_title)
		ELSE
				IF g_enable_mobile_title = FALSE
				THEN
						CALL m_window.setText("")
				ELSE
						CALL m_window.setText(m_title)
				END IF
		END IF

		LET TERMINATE = FALSE

		WHILE TERMINATE = FALSE
				MENU
				
						ON TIMER g_timed_checks_time
								CALL connection_test()
								CALL timed_upload_queue_data()
								
						BEFORE MENU
								CALL connection_test()
								LET f_words = "Here you can take some photos, and upload them to the cloud. When you confirm your selection, the photos will be compressed and stored locally in a local database ready for transport." || "\n\n" ||
															"When you have a solid network connection and access to the webserver, the app will send the payload to the webservice and await confirmation before removing the image from the queue." || "\n\n" ||
															"You can save as many photos in the queue as you wish and they will only be removed once they have been successfully recieved by the cloud."
								DISPLAY f_words TO words
								LET f_queue_count = 0
								INITIALIZE f_temp_img_queue TO NULL
								
						ON ACTION CLOSE
								LET TERMINATE = TRUE
								EXIT MENU
						ON ACTION bt_takep
								IF f_temp_img_queue.getLength() = 0
								THEN
										LET f_index = 1
								END IF
								CALL ui.Interface.frontCall("mobile","takePhoto",[],[f_temp_img_queue[f_index]])
								DISPLAY f_temp_img_queue[f_index]
								IF f_temp_img_queue[f_index] IS NOT NULL
								THEN
										LET f_queue_count = f_queue_count + 1
										IF f_queue_count = 1
										THEN
												DISPLAY f_queue_count || " Photo in queue" TO status
										ELSE
												DISPLAY f_queue_count || " Photo(s) in queue" TO status
										END IF
										LET f_index = f_index + 1
								ELSE
										#DISPLAY "Action cancelled by user"
										IF f_temp_img_queue.getLength() = 1
										THEN
												INITIALIZE f_temp_img_queue TO NULL
										END IF
								END IF
						ON ACTION bt_choosep
								IF f_temp_img_queue.getLength() = 0
								THEN
										LET f_index = 1
								END IF
								CALL ui.Interface.frontCall("mobile","choosePhoto",[],[f_temp_img_queue[f_index]])
								DISPLAY f_temp_img_queue[f_index]
								IF f_temp_img_queue[f_index] IS NOT NULL
								THEN
										LET f_queue_count = f_queue_count + 1
										IF f_queue_count = 1
										THEN
												DISPLAY f_queue_count || " Photo in temporary queue" TO status
										ELSE
												DISPLAY f_queue_count || " Photo(s) in temporary queue" TO status
										END IF
										LET f_index = f_index + 1
								ELSE
										#DISPLAY "Action cancelled by user"
										IF f_temp_img_queue.getLength() = 1
										THEN
												INITIALIZE f_temp_img_queue TO NULL
										END IF
								END IF
						ON ACTION bt_cancel
								IF f_temp_img_queue.getLength() = 0
								THEN
										CALL fgl_winmessage("Image Upload", "There are no images in the temporary queue to cancel!", "information")
								ELSE
										IF reply_yn("N"," ","Are you sure you want to clear the temporary image queue?")
										THEN
												LET f_queue_count = 0
												INITIALIZE f_temp_img_queue TO NULL
												DISPLAY " " TO status
												MESSAGE "Cleared image queue!"
										END IF
								END IF
						ON ACTION bt_confirm
								IF f_temp_img_queue.getLength() = 0
								THEN
										CALL fgl_winmessage("Image Upload", "There are no images in the temporary image queue to upload!", "information")
								ELSE
										FOR f_index = 1 TO f_temp_img_queue.getLength()
												IF f_temp_img_queue[f_index] IS NOT NULL
												THEN
														DISPLAY "Grabbing image: " || f_temp_img_queue[f_index]
														CALL fgl_getfile(f_temp_img_queue[f_index],"imageupload_" || f_index)
														DISPLAY "Encoding image into Base64 ready for transport..."
														LET f_payload = util.Strings.base64Encode("imageupload_" || f_index)
														DISPLAY "Loading payload into local delivery queue..."
														CALL load_payload(g_user,"IMAGE",f_payload)
																RETURNING m_ok
												END IF
										END FOR
										IF reply_yn("Y"," ","Images loaded successfully! Do you wish to upload them now?")
										THEN
												CALL connection_test()
												IF g_online = "NONE"
												THEN
														IF g_enable_timed_image_upload = TRUE AND g_timed_checks_time > 0
														THEN
																CALL fgl_winmessage("Warning!", "You are currently offline, we will automatically try again when you are next online.", "information")
																LET f_queue_count = 0
																INITIALIZE f_temp_img_queue TO NULL
																DISPLAY " " TO status 
														ELSE
																CALL fgl_winmessage("Warning!", "You are currently offline, please try again when you are online.", "information")
																LET f_queue_count = 0
																INITIALIZE f_temp_img_queue TO NULL
																DISPLAY " " TO status
														END IF
												ELSE
														CALL upload_image_payload(FALSE)
														LET f_queue_count = 0
														INITIALIZE f_temp_img_queue TO NULL
														DISPLAY " " TO status
												END IF
										ELSE
												MESSAGE "Images loaded into upload queue!"
												LET f_queue_count = 0
												INITIALIZE f_temp_img_queue TO NULL
												DISPLAY " " TO status
										END IF
								END IF
						ON ACTION bt_go_back
								LET m_instruction = "go_back"
								LET TERMINATE = TRUE
								EXIT MENU								
							
				END MENU
		END WHILE

		CASE m_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
				WHEN "go_back"
						CLOSE WINDOW w
						CALL open_application()
				WHEN "logout"
						INITIALIZE g_user TO NULL
						INITIALIZE g_logged_in TO NULL
						DISPLAY "Logged out successfully!"
						CLOSE WINDOW w
						CALL login_screen()
				OTHERWISE
						CALL ui.Interface.refresh()
						CALL close_app()
		END CASE

END FUNCTION

################################################################################

################################################################################
#Module Functions...
################################################################################

FUNCTION connection_test() #Test online connectivity, call this whenever opening new window!
		IF g_enable_timed_connect = TRUE
		THEN
				CALL test_connectivity(m_info.deployment_type)
				IF g_online = "NONE" AND m_info.deployment_type = "GMA" OR g_online = "NONE" AND m_info.deployment_type = "GMI"
				THEN
						IF g_enable_mobile_title = FALSE
						THEN
								CALL m_window.setText(" *Working Offline* ")
						ELSE
								CALL m_window.setText(" *Working Offline* " || m_title)
						END IF
				ELSE
						IF g_enable_mobile_title = FALSE
						THEN
								CALL m_window.setText("")
						ELSE
								CALL m_window.setText(m_title)
						END IF
				END IF
		END IF
END FUNCTION
#
#
#
#
FUNCTION update_connection_image(f_image) #Used to update connection image within the demo about page

		DEFINE
				f_image STRING
		
		LET m_form = m_window.getForm()
		IF g_online = "NONE"
		THEN
				CALL m_form.setElementImage(f_image,"disconnected")
				DISPLAY "Services Disconnected" TO connected
		ELSE
				CALL m_form.setElementImage(f_image,"connected")
				DISPLAY "Services Connected" TO connected
		END IF 
END FUNCTION

################################################################################