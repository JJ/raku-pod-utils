use v6.c;

unit module Pod::Utilities::Build:ver<0.0.1>;

=begin pod

=head1 NAME

Pod::Utilities::Build - Set of helper functions to ease the creation of new
Pods elements.

=head1 SYNOPSIS

    use Pod::Utilities::Build;

    # time to build Pod::* elements!
    say pod-bold("bold text");

=head1 DESCRIPTION

Pod::Utilities::Build is a set of routines that help you to create new 
Pod elements.

=head1 AUTHORS

Alexander Mouquin <@Mouq>

Will Coleda <@coke>

Rob Hoelz <@hoelzro>

<@timo>

Moritz Lenz <@moritz>

Juan Julián <@JJ>

<@MasterDuke17>

Zoffix Znet <@zoffixznet>

Antonio <@antoniogamiz>

=head1 COPYRIGHT AND LICENSE

Copyright 2019 Perl6 team

This library is free software; you can redistribute it and/or modify
it under the Artistic License 2.0. 

=end pod

#| Creates a new Pod::Block::Named object (with :name set to "TITLE")
#| and populates it with a Pod::Block::Para containing $title.
sub pod-title($title) is export {
    Pod::Block::Named.new(
        name     => "TITLE",
        contents => Array.new(
            Pod::Block::Para.new(
                contents => [$title],
            )
        )
    );
}

#| Creates a new Pod::Block::Named object (with :name set to "pod")
#| and populates it with a title (using pod-title) and @blocks.
sub pod-with-title($title, *@blocks) is export {
    Pod::Block::Named.new(
        name     => "pod",
        contents => [
            flat pod-title($title), @blocks
        ]
    );
}

#| Creates a Pod::Block::Para object with contents set to @contents.
sub pod-block(*@contents) is export {
    Pod::Block::Para.new(:@contents);
}

#| Creates a Pod::FormattingCode (type Link) object with contents set to $text
#| and meta set to $url.
sub pod-link($text, $url) is export {
    Pod::FormattingCode.new(
        type     => 'L',
        contents => [$text],
        meta     => [$url],
    );
}

#| Creates a Pod::FormattingCode (type Bold) object with contents set to $text
sub pod-bold($text) is export {
    Pod::FormattingCode.new(
        type     => 'B',
        contents => [$text],
    );
}

#| Creates a Pod::FormattingCode (type C) object with contents set to $text
sub pod-code($text) is export {
    Pod::FormattingCode.new(
        type     => 'C',
        contents => [$text],
    );
}

#| Creates a Pod::Item object with contents set to @contents a level to $level
sub pod-item(*@contents, :$level = 1) is export {
    Pod::Item.new(
        :$level,
        :@contents,
    );
}

#| Creates a Pod::Heading object with level set $level and contents initialized
#| with a Pod::Block::Para object containing $name.
sub pod-heading($name, :$level = 1) is export {
    Pod::Heading.new(
        :$level,
        :contents[pod-block($name)],
    );
}

#| Creates a Pod::Block::Table object with the headers @headers and rows @contents. 
#| $caption is set to "".
sub pod-table(@contents, :@headers) is export {
    Pod::Block::Table.new(
        |(:@headers if @headers),
        :@contents,
        :caption("")
    );
}

#| Given an array of Pod objects, lower the level of every heading following
#| the next formula => current-level - $by + $to, where $by is the level of the
#| first heading found in the array.
sub pod-lower-headings(@content, :$to = 1) is export {
    my $by = @content.first(Pod::Heading).level;
    return @content unless $by > $to;
    my @new-content;
    for @content {
        @new-content.append: $_ ~~ Pod::Heading
            ?? Pod::Heading.new: :level(.level - $by + $to) :contents[.contents]
            !! $_;
    }
    @new-content;
}

# vim: expandtab shiftwidth=4 ft=perl6
