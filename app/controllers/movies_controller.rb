class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #If neither ratings or sort_by have keys, then this is either the first time visiting the page
    # or the user has been redirected. Either way, it is safe to assign the session values to the
    # params keys. If it is the first time visiting, they will stay nil and show the normal view,
    # if redirected, will show the page with the settings saved. Also preserves flash messages
    if params[:ratings].nil? and params[:sort_by].nil?
      params[:ratings] = session[:ratings]
      params[:sort_by] = session[:sort_by]
    end
    @all_ratings = Movie.all_ratings
    @ratings = params[:ratings]
    #if user unchecks all boxes, replace with session params. If first visit, check everything
    if @ratings.nil?
      if session[:ratings].nil?
        @ratings = {"G" => "1", "PG" => "1", "PG-13" => "1", "R" => "1"}
      else
        @ratings = session[:ratings]
      end
      @movies = Movie.all
    else
      @movies = Movie.find_all_by_rating(@ratings.keys)
    end
    if params[:sort_by] == 'title'
      @title_class = "hilite"
      @movies = @movies.sort_by(&:title)
    elsif params[:sort_by] == 'release_date'
      @movies = @movies.sort_by(&:release_date)
      @release_date_class = "hilite"
    end
    session[:ratings] = @ratings
    session[:sort_by] = params[:sort_by]
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
