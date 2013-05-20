# ===================================================================================================
#                           _  __     _ _
#                          | |/ /__ _| | |_ _  _ _ _ __ _
#                          | ' </ _` | |  _| || | '_/ _` |
#                          |_|\_\__,_|_|\__|\_,_|_| \__,_|
#
# This file is part of the Kaltura Collaborative Media Suite which allows users
# to do with audio, video, and animation what Wiki platfroms allow them to do with
# text.
#
# Copyright (C) 2006-2011  Kaltura Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http:#www.gnu.org/licenses/>.
#
# @ignore
# ===================================================================================================
require 'kaltura_client.rb'

module Kaltura

	class KalturaWidevineFlavorAssetOrderBy
		CREATED_AT_ASC = "+createdAt"
		DELETED_AT_ASC = "+deletedAt"
		SIZE_ASC = "+size"
		UPDATED_AT_ASC = "+updatedAt"
		CREATED_AT_DESC = "-createdAt"
		DELETED_AT_DESC = "-deletedAt"
		SIZE_DESC = "-size"
		UPDATED_AT_DESC = "-updatedAt"
	end

	class KalturaWidevineFlavorParamsOrderBy
	end

	class KalturaWidevineFlavorParamsOutputOrderBy
	end

	class KalturaWidevineFlavorAsset < KalturaFlavorAsset
		# License distribution window start date 
		# 	 
		attr_accessor :widevine_distribution_start_date
		# License distribution window end date
		# 	 
		attr_accessor :widevine_distribution_end_date
		# Widevine unique asset id
		# 	 
		attr_accessor :widevine_asset_id

		def widevine_distribution_start_date=(val)
			@widevine_distribution_start_date = val.to_i
		end
		def widevine_distribution_end_date=(val)
			@widevine_distribution_end_date = val.to_i
		end
		def widevine_asset_id=(val)
			@widevine_asset_id = val.to_i
		end
	end

	class KalturaWidevineFlavorParams < KalturaFlavorParams

	end

	class KalturaWidevineFlavorParamsOutput < KalturaFlavorParamsOutput

	end

	class KalturaWidevineFlavorAssetBaseFilter < KalturaFlavorAssetFilter

	end

	class KalturaWidevineFlavorParamsBaseFilter < KalturaFlavorParamsFilter

	end

	class KalturaWidevineFlavorAssetFilter < KalturaWidevineFlavorAssetBaseFilter

	end

	class KalturaWidevineFlavorParamsFilter < KalturaWidevineFlavorParamsBaseFilter

	end

	class KalturaWidevineFlavorParamsOutputBaseFilter < KalturaFlavorParamsOutputFilter

	end

	class KalturaWidevineFlavorParamsOutputFilter < KalturaWidevineFlavorParamsOutputBaseFilter

	end


	# WidevineDrmService serves as a license proxy to a Widevine license server
	#  
	class KalturaWidevineDrmService < KalturaServiceBase
		def initialize(client)
			super(client)
		end

		# Get license for encrypted content playback
		# 	 
		def get_license(flavor_asset_id)
			kparams = {}
			client.add_param(kparams, 'flavorAssetId', flavor_asset_id);
			client.queue_service_action_call('widevine_widevinedrm', 'getLicense', kparams);
			if (client.is_multirequest)
				return nil;
			end
			return client.do_queue();
		end
	end

	class KalturaClient < KalturaClientBase
		attr_reader :widevine_drm_service
		def widevine_drm_service
			if (@widevine_drm_service == nil)
				@widevine_drm_service = KalturaWidevineDrmService.new(self)
			end
			return @widevine_drm_service
		end
	end

end
