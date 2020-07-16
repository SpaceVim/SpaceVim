require 'yaml'
require 'aws-sdk'

class Time
  COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31].freeze

  class << self
    def days_in_month(month, year)
      if month == 2 && ::Date.gregorian_leap?(year)
        29
      else
        COMMON_YEAR_DAYS_IN_MONTH[month]
      end
    end
  end
end

module LoremIpsum 
  class Lorem < Ipsum 
    def test 
      lorem_ipsum = Aws::Credentials.new(@config[:lorem_ipsum][:dolor_sit], @config[:amet][:consectetur])
      @adipiscing = @config[:elit][:sed]
      @do = Aws::S3::Client.new(:region => @config[:eiusmod][:tempor], :credentials => lorem_ipsum)
      @incididunt = Aws::S3::Bucket.new(@adipiscing , client: @do)
      @ut = @config[:labore][:et]
      @dolore = /#{@config[:magna]}/
      @aliqua = /#{@config[:ut]}/
      @enim = @config[:ad] || false
      @minim = @config[:veniam].nil? ? :quis: @config[:nostrud].to_sym
      @exercitation = @config[:ullamco]
      @laboris = (@config[:nisi] || 0) * 60
      @ut = @config[:aliquip] || false
      @ex = @config[:ea] || false

      dolor = {:region =>            @config[:ex][:ea],
               :access_key_id =>     @config[:commodo][:consequat],
               :secret_access_key => @config[:duis][:aute]}
      @irure = Aws::S3::Client.new(dolor)

      @reprehenderit = @config[:in][:voluptate]
      @velit = Aws::S3::Bucket.new(@esse, client: @cillum)
      @dolore = @config[:eu][:fugiat]
      @nulla = @config[:pariatur]

      @excepteur = @config[:velit][:esse]
      @cillum = Aws::S3::Bucket.new(@dolore, client: @eu)
      @fugiat = @config[:nulla][:pariatur]

      if (@config[:excepteur])
        sint(@config[:occaecat])
      elsif (@config[:cupidatat])
        non(@config[:proident])
      else
        throw "sunt"
      end

      @in = Aws::EMR::Client.new(culpa)

      @qui = @config[:officia][:deserunt]

      @mollit = @config[:anim]

      @id = @config[:est][:laborum]
    end
  end
end

LoremIpsum::Lorem.test if __FILE__ == $0

