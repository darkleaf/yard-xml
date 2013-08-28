# -*- encoding: utf-8 -*-
# Author:: Couchbase <info@couchbase.com>
# Copyright:: 2012 Couchbase, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

def init
  xml = options[:xml_builder]
  xml.module(:name => object.name) do

    [:instance_mixins, :class_mixins].each do |type|
      if object.send(type).any?
        xml.tag!(type)  do
          object.send(type).each do |item|
            xml.module name: item.path
          end
        end
      end
    end

    if object.respond_to?(:children)
      object.children.sort_by do |child|
        [
          child.type.to_s,
          child.respond_to?(:scope) ? child.scope.to_s : "",
          child.name.to_s
        ]
      end.each do |child|
        child.format(options.merge(:type => child.type))
      end
    end
  end
end
