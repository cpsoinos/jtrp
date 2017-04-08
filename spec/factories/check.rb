require 'factory_girl'

FactoryGirl.define do
  factory :check do
    statement
    data do
      { 'thumbnails' => [
        {
          'large' => 'https://s3-us-west-2.amazonaws.com/assets.lob.com/chk_284afc4b3cd6eec1_thumb_large_1.png?AWSAccessKeyId=AKIAIILJUBJGGIBQDPQQ&Expires=1494214340&Signature=%2BM0X%2FkZyo0bbxhXFpywO99jJbP8%3D',
          'small' => 'https://s3-us-west-2.amazonaws.com/assets.lob.com/chk_284afc4b3cd6eec1_thumb_small_1.png?AWSAccessKeyId=AKIAIILJUBJGGIBQDPQQ&Expires=1494214340&Signature=9E14eyzcDFL%2BLHq9LQ%2FYNykyoAs%3D',
          'medium' => 'https://s3-us-west-2.amazonaws.com/assets.lob.com/chk_284afc4b3cd6eec1_thumb_medium_1.png?AWSAccessKeyId=AKIAIILJUBJGGIBQDPQQ&Expires=1494214340&Signature=wWrHn%2FYC%2Fygrbg0aX4csFY2yODs%3D'
        },
        {
          'large' => 'https://s3-us-west-2.amazonaws.com/assets.lob.com/chk_284afc4b3cd6eec1_thumb_large_2.png?AWSAccessKeyId=AKIAIILJUBJGGIBQDPQQ&Expires=1494214340&Signature=UHn5Eqrx3qNao4ez9Vlj9qT6VqM%3D',
          'small' => 'https://s3-us-west-2.amazonaws.com/assets.lob.com/chk_284afc4b3cd6eec1_thumb_small_2.png?AWSAccessKeyId=AKIAIILJUBJGGIBQDPQQ&Expires=1494214340&Signature=h1BXLUu6xyd83PvxyeXOuvkZxRA%3D',
          'medium' => 'https://s3-us-west-2.amazonaws.com/assets.lob.com/chk_284afc4b3cd6eec1_thumb_medium_2.png?AWSAccessKeyId=AKIAIILJUBJGGIBQDPQQ&Expires=1494214340&Signature=FW8whqRshxI6IOmVA%2FmfVJXlcl8%3D'
        }
      ] }
    end
  end
end
