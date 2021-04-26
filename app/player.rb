class Player
    attr_gtk 
    attr_accessor :left_mouse_state, :right_mouse_state, :selected_unit


    def initialize(init_args)
        @left_mouse_state = "UP"
        @right_mouse_state = "UP"
        @args = init_args[:args]
    end


    def inputs()
        mouse_inputs()
    end


    def mouse_inputs()
        left_mouse()
        right_mouse()
    end


    def left_mouse()
        if(@args.inputs.mouse.button_left)
            left_mouse_select()
        elsif(@left_mouse_state == "DOWN")
            left_mouse_accept()
        end
    end


    def left_mouse_select()
        if(@left_mouse_state == "UP")
            @left_mouse_state = "DOWN"
        end
    end


    def left_mouse_accept()
        if(!@args.inputs.mouse.button_left)
            point = args.inputs.mouse.point
            mouse_tile_pos = args.state.grid[0][0].
                coord_to_grid({x: point[0], y: point[1]})

            if(in_bounds(mouse_tile_pos))
                position = args.state.units[mouse_tile_pos[:row]][mouse_tile_pos[:col]]
                if(@selected_unit != nil && (position == nil || position.type != "KNIGHT"))
                    puts  @args.state.units[mouse_tile_pos[:row]][mouse_tile_pos[:col]]
                    if(@args.state.units[mouse_tile_pos[:row]][mouse_tile_pos[:col]] == nil)
                        if(@args.state.
                        grid[mouse_tile_pos[:row]][mouse_tile_pos[:col]].marked == 0)
                            find_path_command(mouse_tile_pos) 
                        end
                    else
                        target_enemy_command(mouse_tile_pos)
                    end
                else
                    args.state.knights.each do |knight|
                        if(mouse_tile_pos == knight.get_tile_position)
                            @selected_unit = knight
                        end
                    end
                end

                @left_mouse_state = "UP"
            end
        end
    end


    def right_mouse()
        if(!@args.inputs.mouse.button_right && @right_mouse_state == "UP")
            @right_mouse_state = "DOWN"
        elsif(@args.inputs.mouse.button_right && @right_mouse_state == "DOWN")
            puts @args.inputs.mouse.button_right && @right_mouse_state == "DOWN" 
            @selected_unit = nil
            @right_mouse_state = "UP"
        end
    end


    def find_path_command(mouse_tile_pos)
        @selected_unit.find_path_to_target(args.state.grid, args.state.units, 
            mouse_tile_pos)
    end


    def target_enemy_command(mouse_tile_pos)
        @selected_unit.attack_target = @args.state.grid[mouse_tile_pos[:row]][mouse_tile_pos[:col]]
        manhattan = @selected_unit.find_manhattan(@selected_unit.attack_target)

        puts manhattan
        if(manhattan > 1)
            @selected_unit.find_move_target(@args.state.grid, @args.state.units)
            find_path_command(@selected_unit.attack_target.get_tile_position)
        end
    end


    def in_bounds(mouse_tile_pos)
        return mouse_tile_pos[:row] >= 0 && mouse_tile_pos[:row] <= @args.state.grid[:max_y] &&
            mouse_tile_pos[:col] >= 0 && mouse_tile_pos[:col] <= @args.state.grid[:max_x]
    end


    # 1. Create a serialize method that returns a hash with all of
    #    the values you care about.
    def serialize()
        { left_mouse_state: @left_mouse_state, selected_unit: @selected_unit,
        right_mouse_state: @right_mouse_state }
    end


    # 2. Override the inspect method and return ~serialize.to_s~.
    def inspect()
        serialize.to_s()
    end


    # 3. Override to_s and return ~serialize.to_s~.
    def to_s()
        serialize.to_s()
    end
end