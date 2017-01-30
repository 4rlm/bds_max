require 'test_helper'

class GeoPlacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @geo_place = geo_places(:one)
  end

  test "should get index" do
    get geo_places_url
    assert_response :success
  end

  test "should get new" do
    get new_geo_place_url
    assert_response :success
  end

  test "should create geo_place" do
    assert_difference('GeoPlace.count') do
      post geo_places_url, params: { geo_place: { account: @geo_place.account, address_components: @geo_place.address_components, aspects: @geo_place.aspects, city: @geo_place.city, hierarchy: @geo_place.hierarchy, img_url: @geo_place.img_url, latitude: @geo_place.latitude, longitude: @geo_place.longitude, map_url: @geo_place.map_url, phone: @geo_place.phone, place_id: @geo_place.place_id, reference: @geo_place.reference, reviews: @geo_place.reviews, sfdc_id: @geo_place.sfdc_id, state: @geo_place.state, street: @geo_place.street, website: @geo_place.website, zip: @geo_place.zip } }
    end

    assert_redirected_to geo_place_url(GeoPlace.last)
  end

  test "should show geo_place" do
    get geo_place_url(@geo_place)
    assert_response :success
  end

  test "should get edit" do
    get edit_geo_place_url(@geo_place)
    assert_response :success
  end

  test "should update geo_place" do
    patch geo_place_url(@geo_place), params: { geo_place: { account: @geo_place.account, address_components: @geo_place.address_components, aspects: @geo_place.aspects, city: @geo_place.city, hierarchy: @geo_place.hierarchy, img_url: @geo_place.img_url, latitude: @geo_place.latitude, longitude: @geo_place.longitude, map_url: @geo_place.map_url, phone: @geo_place.phone, place_id: @geo_place.place_id, reference: @geo_place.reference, reviews: @geo_place.reviews, sfdc_id: @geo_place.sfdc_id, state: @geo_place.state, street: @geo_place.street, website: @geo_place.website, zip: @geo_place.zip } }
    assert_redirected_to geo_place_url(@geo_place)
  end

  test "should destroy geo_place" do
    assert_difference('GeoPlace.count', -1) do
      delete geo_place_url(@geo_place)
    end

    assert_redirected_to geo_places_url
  end
end
