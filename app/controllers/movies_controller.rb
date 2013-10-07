class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @ratings = params[:ratings]
    if @ratings.nil?
      @ratings = {"G" => "1", "PG" => "1", "PG-13" => "1", "R" => "1"}
      @movies = Movie.all
    else
      @movies = Movie.find_all_by_rating(@ratings.keys)
    end

    if params[:sort_by] == 'title'
      @title_class = "hilite"
      @movies = @movies.sort_by(&:title)
      #@movies = Movie.all(:order => 'movies.title')
    elsif params[:sort_by] == 'release_date'
      @movies = @movies.sort_by(&:release_date)
      @release_date_class = "hilite"
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
