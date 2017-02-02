module LocationsHelper
    def add_http(url)
        return url.include?("http") ? url : "http://#{url}"
    end
end
