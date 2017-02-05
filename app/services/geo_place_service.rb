class GeoPlaceService

    def geo_places_starter
        # cores = Core.all
        # cores = [Core.all[120]]
        # puts "\n\n#{cores.count}\n\n"
        # puts "\n\n#{cores.first.sfdc_acct}\n\n"
        # cores.each do |core|
        #     get_spot(core)
        # end
    end

    def get_spot(core)
        # client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
        # spots = client.spots_by_query("#{core.sfdc_acct} near #{core.full_address}", name: core.sfdc_acct, types: ["car_dealer"], radius: 1)
        # return if spots.empty?
        #
        # spot = spots.first
        # detail = client.spot(spot.reference)
        #
        # create_geo_place(core, spot, detail)
    end

    def create_geo_place(core, spot, detail)
        # comp = detail.address_components
        #
        # street = comp[0]["short_name"] + " " + comp[1]["short_name"]
        # city = comp[2]["short_name"]
        # state = comp[3]["short_name"]
        # zip = comp[5]["short_name"]


        # img = detail.photos[0]
        # img_url = img ? img.fetch_url(300) : nil
        #
        # GeoPlace.create(sfdc_id: "test", account: spot.name, street: street, city: city, state: state, zip: zip, latitude: spot.lat, longitude: spot.lng, phone: detail.formatted_phone_number, website: detail.website, map_url: detail.url, img_url: "img_url", hierarchy: "Geo", place_id: core.sfdc_acct, address_components: "n/a", reference: "n/a", aspects: core.full_address, reviews: "n/a")
    end


end
