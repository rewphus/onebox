module Onebox
    module Engine
        class GiantbombOnebox
            include Engine
            include JSON
            
            matches_regexp /^https?:\/\/www\.giantbomb\.com\/.+?\/.+?\/$/
            
            def url
                game_id = @url.match(/^https?:\/\/www\.giantbomb\.com\/.+?\/(.+)?\/$/)[1]
                "http://www.giantbomb.com/api/game/#{game_id}/?api_key=1f2fbb08dde5a07ceb29f21e581301f3105598e8&format=json"
            end
            
            def to_html
                game = raw
                
                #Prepare data fields
                
                #release date
                release = game["results"]["original_release_date"];
                release_label = "First Released"
                release_date = ""
                if(release == nil || release == 'null' || release == '')
                    begin
                        release_date = DateTime.new(game["results"]["expected_release_year"].to_i, game["results"]["expected_release_month"].to_i,game["results"]["expected_release_day"].to_i)
                        release = release_date.strftime("%B %-d, %Y")
                        rescue
                        release = "TBA"
                    end
                    release_label = "Expected Release"
                    else
                    release_date = DateTime.strptime(game["results"]["original_release_date"].to_s, '%Y-%m-%d %H:%M:%s')
                    release = release_date.strftime("%B %-d, %Y")
                end
                
                #Genres
                genres = game["results"]["genres"];
                genreFormatted = "N/A";
                if(genres != nil && genres.length > 0)
                    genreFormatted = genres.map {|x| x["name"] } * ", ";
                end
                #platforms
                platforms = game["results"]["platforms"];
                platFormatted = "N/A";
                if(platforms != nil && platforms.length > 0)
                    platFormatted = platforms.map {|x| x["name"] } * ", ";
                end
                
                #Developers
                devs = game["results"]["developers"];
                devsFormatted = "N/A";
                if(devs != nil && devs.length > 0)
                    devsFormatted = devs.map {|x| x["name"] } * ", ";
                end
                
                #description
                desc = game["results"]["deck"];
                if(desc == nil || desc.length < 1)
                    desc = "N/A";
                end
                
                #image
                begin
                    img = game["results"]["image"]["small_url"];
                    if(img == nil || img.length < 1)
                        img = "";
                    end
                    rescue
                    img = "";
                end
                
                
                #name
                name = game["results"]["name"];
                if(name == nil || name.length < 1)
                    name = "N/A"
                end
                
                "
                
                <img src='#{img}' style='float:left; max-width:690px; max-height:500pc; max-width:100%;'>
                <div class='onebox-result' style='background:white; border-radius:7px;'>
                <div class='source'>
                
                </div>
                <div class='onebox-result-body'>
                <div class='gbimage' style='float:left; max-width:690px; max-height: 500px; max-width:100%;'>
                
                </div>
                <div class='info' style='display:inline-block;width: 100%;padding: 10px;'>
                <h4>#{game["results"]["name"]}</h4>
                #{desc}
                <h4>#{release_label}</h4> #{release}
                <h4>Platforms</h4>
                #{platFormatted}
                <h4>Developers</h4>
                #{devsFormatted}
                <h4>Genres</h4>
                #{genreFormatted}
                </div>
                <br>
                <br>
                <a href='#{@url}' class='track-link' target='_blank'>
                Find out more at Giant Bomb
                </a>
                </div>
                <div class='clearfix'></div>
                </div>
                "
            end
        end
    end
end
