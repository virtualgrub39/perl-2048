#!/usr/bin/env perl
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";   

use Raylib;

my $WINDOW_SZ = 500;
my $FONT_SZ = 40;

my $COLOR_BG = Raylib::Color(56, 63, 81);
my $COLOR_FG = Raylib::Color(221, 219, 241);
my $COLOR_HL = Raylib::Color(233, 138, 21);

my @board = ();
my $BOARD_SZ = 4;

sub game_init {
    for (my $i = 0; $i < $BOARD_SZ; $i++)
    {
        for (my $j = 0; $j < $BOARD_SZ; $j++)
        {
            $board[$i][$j] = 0;
        }
    }

    $board[$BOARD_SZ-1][$BOARD_SZ-1] = 2;
    $board[$BOARD_SZ-2][$BOARD_SZ-1] = 2;
}

sub game_display {
    my $CELL_SZ = $WINDOW_SZ /4.5;
    my $BORDER_SZ = ($WINDOW_SZ - $BOARD_SZ*$CELL_SZ)/5;

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
            if ($board[$j][$i] == 0) {
                next;
            }

            Raylib::draw_rectangle(
                $j * ($CELL_SZ + $BORDER_SZ) + $BORDER_SZ,
                $i * ($CELL_SZ + $BORDER_SZ) + $BORDER_SZ,
                $CELL_SZ,
                $CELL_SZ,
                $COLOR_HL);

            my $c = $board[$j][$i];
            my $text_size = Raylib::measure_text("$c", $FONT_SZ);

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

}

Raylib::init_window($WINDOW_SZ, $WINDOW_SZ, "nyaa <3");

game_init();

until (Raylib::window_should_close()) {
    game_update();

    Raylib::begin_drawing();
    game_display();
    Raylib::end_drawing();
}

Raylib::close_window();
