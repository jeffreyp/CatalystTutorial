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

=head2 form_create

Display a form to create a book.

=cut

sub form_create :Chained('base') :PathPart('form_create') :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(template => 'books/form_create.tt2');
}

=head2 form_create_do

Take info from the form and add to DB.

=cut

sub form_create_do :Chained('base') :PathPart('form_create_do') :Args(0) {
    my ( $self, $c ) = @_;

    my $title = $c->request->params->{title} || 'N/A';
    my $rating = $c->request->params->{rating} || 'N/A';
    my $author_id = $c->request->params->{author_id} || '1';

    my $book = $c->model('DB::Book')->create({
	title => $title,
	rating => $rating,
					     });
    $book->add_to_book_authors({author_id => $author_id});

    $c->stash(book => $book, template => 'books/create_done.tt2');
}

=head2 object

Fetch the specified book object based on book ID and store in stash.

=cut

sub object :Chained('base') :PathPart('id') :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    $c->stash(object => $c->stash->{resultset}->find($id));
    die "Book $id not found!" if !$c->stash->{object};

    $c->log->debug("***INSIDE OBJECT METHOD FOR obj id=$id***");
}

=head2 delete

Delete a book.

=cut

sub delete :Chained('object') :PathPart('delete') :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{object}->delete;
    $c->stash->{status_msg} = "Book deleted.";
    $c->response->redirect($c->uri_for($self->action_for('list'),
			   {status_msg=>"Book deleted."}));
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
