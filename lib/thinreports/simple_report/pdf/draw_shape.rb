# frozen_string_literal: true

require 'thinreports/renderer/text_block'
require 'thinreports/renderer/image'
require 'thinreports/renderer/page_number'

module Thinreports
  module SimpleReport
    module Pdf
      module DrawShape
        # @param [Thinreports::Core::Shape::TextBlock::Internal] shape
        def draw_shape_tblock(shape)
          Thinreports::Renderer::TextBlock.new(self, shape).render
        end

        def draw_shape_pageno(shape, page_no, page_count)
          Thinreports::Renderer::PageNumber.new(self, shape).render(no: page_no, count: page_count)
        end

        # @param [Thinreports::Core::Shape::Basic::Internal] shape
        def draw_shape_image(shape)
          Thinreports::Renderer::Image.new(self, shape).render
        end

        # @param [Thinreports::Core::Shape::ImageBlock::Internal] shape
        def draw_shape_iblock(shape)
          return if blank_value?(shape.src)

          x, y, w, h = shape.format.attributes.values_at('x', 'y', 'width', 'height')
          style = shape.style.finalized_styles

          image_box(
            shape.src, x, y, w, h,
            position_x: image_position_x(style['position-x']),
            position_y: image_position_y(style['position-y'])
          )
        end

        # @param [Thinreports::Core::Shape::Text::Internal] shape
        def draw_shape_text(shape)
          x, y, w, h = shape.format.attributes.values_at('x', 'y', 'width', 'height')
          text(
            shape.texts.join("\n"), x, y, w, h,
            build_text_attributes(shape.style.finalized_styles)
          )
        end

        # @param [Thinreports::Core::Shape::Basic::Internal] shape
        def draw_shape_ellipse(shape)
          cx, cy, rx, ry = shape.format.attributes.values_at('cx', 'cy', 'rx', 'ry')
          ellipse(cx, cy, rx, ry, build_graphic_attributes(shape.style.finalized_styles))
        end

        # @param [Thinreports::Core::Shape::Basic::Internal] shape
        def draw_shape_line(shape)
          x1, y1, x2, y2 = shape.format.attributes.values_at('x1', 'y1', 'x2', 'y2')
          line(x1, y1, x2, y2, build_graphic_attributes(shape.style.finalized_styles))
        end

        # @param [Thinreports::Core::Shape::Basic::Internal] shape
        def draw_shape_rect(shape)
          x, y, w, h = shape.format.attributes.values_at('x', 'y', 'width', 'height')
          rect_attributes = build_graphic_attributes(shape.style.finalized_styles) do |attrs|
            attrs[:radius] = shape.format.attributes['border-radius']
          end
          rect(x, y, w, h, rect_attributes)
        end
      end
    end
  end
end