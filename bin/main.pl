#!/usr/bin/env perl
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";   

use Raylib;

my $WINDOW_SZ = 600;
my $BOARD_SZ = 4;

my $COLOR_BG = Raylib::Color(56, 63, 81);
my $COLOR_FG = Raylib::Color(221, 219, 241);
my @COLORS = (
    Raylib::Color(238, 228, 218), # 2
    Raylib::Color(235, 216, 182), # 4
    Raylib::Color(242, 176, 117), # 8
    Raylib::Color(246, 147, 97), # 16
    Raylib::Color(246, 122, 93), # 32
    Raylib::Color(244, 89, 53), # 64
    Raylib::Color(242, 207, 87), # 128
    Raylib::Color(237, 204, 98), # 256
    Raylib::Color(237, 200, 80), # 512
    Raylib::Color(237, 197, 63), # 1024
    Raylib::Color(237, 194, 45), # 2048
);

my @board = ();
my $tiles = 0; # used to check for loosing condition

my $CELL_SZ = ($WINDOW_SZ * 0.9) / $BOARD_SZ;
my $FONT_SZ = $CELL_SZ/2;
my $BORDER_SZ = ($WINDOW_SZ - $BOARD_SZ*$CELL_SZ) / ($BOARD_SZ+1);

my $board_changed = 0;

sub game_init {
    for (my $i = 0; $i < $BOARD_SZ; $i++)
    {
        for (my $j = 0; $j < $BOARD_SZ; $j++)
        {
            $board[$i][$j] = 0;
        }
    }

    spawn_tile();
    spawn_tile();
    
    $board_changed = 0;
}

sub game_display {
    

    Raylib::clear_background($COLOR_BG);

    # BACKGROUND

    for (my $i = 0; $i < $BOARD_SZ; $i++)
    {
        for (my $j = 0; $j < $BOARD_SZ; $j++)
        {
            Raylib::draw_rectangle(
                $j * ($CELL_SZ + $BORDER_SZ) + $BORDER_SZ,
                $i * ($CELL_SZ + $BORDER_SZ) + $BORDER_SZ,
                $CELL_SZ,
                $CELL_SZ,
                $COLOR_FG);
        }
    }

    # CELLS

    for (my $i = 0; $i < $BOARD_SZ; $i++)
    {
        for (my $j = 0; $j < $BOARD_SZ; $j++)
        {
            if ($board[$i][$j] == 0) {
                next;
            }

            my $c = $board[$i][$j];
            my $text_size = Raylib::measure_text("$c", $FONT_SZ);
            my $color = $COLORS[int(log($c)/log(2)) - 1];

            Raylib::draw_rectangle(
                $j * ($CELL_SZ + $BORDER_SZ) + $BORDER_SZ,
                $i * ($CELL_SZ + $BORDER_SZ) + $BORDER_SZ,
                $CELL_SZ,
                $CELL_SZ,
                $color);

            Raylib::draw_text(
                "$c",
                $j * ($CELL_SZ + $BORDER_SZ) + $BORDER_SZ + $CELL_SZ/2 - $text_size/2,
                $i * ($CELL_SZ + $BORDER_SZ) + $BORDER_SZ + $CELL_SZ/3,
                $FONT_SZ,
                $COLOR_BG
            );
        }
    }
}

sub game_update {
    my $key = Raylib::get_key_pressed();
    return unless $key;

    $board_changed = 0;

    if ($key == $Raylib::KEY_LEFT) {
        for (my $row = 0; $row < $BOARD_SZ; $row++)
        {
            merge_left($row);
        }
    } elsif ($key == $Raylib::KEY_RIGHT)
    {
        for (my $row = 0; $row < $BOARD_SZ; $row++)
        {
            merge_right($row);
        }
    } elsif ($key == $Raylib::KEY_UP)
    {
        for (my $col = 0; $col < $BOARD_SZ; $col++)
        {
            merge_up($col);
        }
    } elsif ($key == $Raylib::KEY_DOWN)
    {
        for (my $col = 0; $col < $BOARD_SZ; $col++)
        {
            merge_down($col);
        }
    }

    if ($board_changed)
    {
        $board_changed = 0;
        spawn_tile();
    }
}

sub spawn_tile() {
    if ($tiles == $BOARD_SZ*$BOARD_SZ)
    {
        return; # TODO: game lost
    }

    while (1) {
        my $x = Raylib::get_random_value(0, $BOARD_SZ-1);
        my $y = Raylib::get_random_value(0, $BOARD_SZ-1);

        next unless $board[$y][$x] == 0;

        $board[$y][$x] = 2;
        $tiles += 1;

        last;
    }
}

sub merge_line {
    my (@line) = @_;

    # 1. collapse 0's

    @line = grep { $_ != 0 } @line;

    # 2. merge the same numbers

    my @merged = (); 
    for (my $i = 0; $i < @line; $i++)
    {
        if ($i + 1 < @line and $line[$i] == $line[$i + 1])
        {
            push @merged, $line[$i] * 2;
            $tiles -= 1;
            $i++;
        } 
        else
        {
            push @merged, $line[$i];
        }
    }

    # 3. fill the rest with 0's

    while (@merged < $BOARD_SZ)
    {
        push @merged, 0;
    }

    return @merged;
}

sub merge_left {
    my ($row) = @_;
    my @line = @{$board[$row]};         # unpack the reference (derefernce if you will :3)
    my @merged = merge_line(@line);     # do the actual work
    my $merged_ref = [@merged];         # create reference to result
    $board[$row] = $merged_ref;         # assign back - replace the row with the new result
    # Not at all confusing - Certainly didn't take me an hour to understand what the hell is going on
    # with the lists, arrays, references and whatnot...
    $board_changed ||= join(',', @line) ne join(',', @merged);
}

sub merge_right {
    my ($row) = @_;
    my @line = reverse @{$board[$row]};        
    my @merged = reverse merge_line(@line);  
    my $merged_ref = [@merged];         
    $board[$row] = $merged_ref;
    $board_changed ||= join(',', @line) ne join(',', @merged);
}

sub merge_up {
    my ($col) = @_;
    my @line = map { $board[$_][$col] } (0..$BOARD_SZ-1);
    my @merged = merge_line(@line);
    for (my $i = 0; $i < $BOARD_SZ; $i++)
    {
        $board[$i][$col] = $merged[$i];
    }
    $board_changed ||= join(',', @line) ne join(',', @merged);
}

sub merge_down {
    my ($col) = @_;
    my @line = reverse map { $board[$_][$col] } (0..$BOARD_SZ-1);
    my @merged = reverse merge_line(@line);
    for (my $i = 0; $i < $BOARD_SZ; $i++)
    {
        $board[$i][$col] = $merged[$i];
    }
    $board_changed ||= join(',', @line) ne join(',', @merged);
}


Raylib::init_window($WINDOW_SZ, $WINDOW_SZ, "perl 2048");

game_init();

until (Raylib::window_should_close())
{
    game_update();

    Raylib::begin_drawing();
    game_display();
    Raylib::end_drawing();
}

Raylib::close_window();
