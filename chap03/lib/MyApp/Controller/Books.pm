package MyApp::Controller::Books;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

MyApp::Controller::Books - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched MyApp::Controller::Books in Books.');
}

=head2 list

Fetch all books and stash in books/list.tt2.

=cut

sub list :Local {
    my ( $self, $c ) = @_;

    $c->stash(books => [$c->model('DB::Book')->all]);
    $c->stash(template => 'books/list.tt2');
}

=head2 url_create

Create a book with the specified title, rating, author.

=cut

sub url_create :Chained('base') :PathPart('url_create') :Args(3) {
    my ( $self, $c, $title, $rating, $author_id ) = @_;

    my $book = $c->model('DB::Book')->create({
	title => $title,
	rating => $rating
					     });

    $book->add_to_book_authors({author_id => $author_id});

    $c->stash(book => $book, template => 'books/create_done.tt2');
    $c->response->header('Cache-Control' => 'no-cache');
}

=head2 base
 
Put common logic to start chained dispatch here.

=cut

sub base :Chained('/') :PathPart('books') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->stash(resultset => $c->model('DB::Book'));
    $c->log->debug('***INSIDE BASE METHOD***');
}

=encoding utf8

=head1 AUTHOR

Jeffrey Pratt

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
