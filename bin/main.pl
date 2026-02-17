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

my $CELL_SZ = $WINDOW_SZ / 4.5;
my $BORDER_SZ = ($WINDOW_SZ - $BOARD_SZ*$CELL_SZ)/5;

my $board_changed;

sub game_init {
    for (my $i = 0; $i < $BOARD_SZ; $i++)
    {
        for (my $j = 0; $j < $BOARD_SZ; $j++)
        {
            $board[$i][$j] = 0;
        }
    }

    $board[$BOARD_SZ-1][$BOARD_SZ-1] = 2;
    $board[$BOARD_SZ-1][$BOARD_SZ-2] = 2;

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

            Raylib::draw_rectangle(
                $j * ($CELL_SZ + $BORDER_SZ) + $BORDER_SZ,
                $i * ($CELL_SZ + $BORDER_SZ) + $BORDER_SZ,
                $CELL_SZ,
                $CELL_SZ,
                $COLOR_HL);

            my $c = $board[$i][$j];
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
