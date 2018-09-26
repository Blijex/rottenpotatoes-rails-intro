#when reopening, use these commmands:
#rake db:drop
#rake db:create
#rake db:migrate
#rake db:seed

#if all checkboxes are unchecked, nothing should show
#sort title and rating while under certain ratings are clicked
#maintain the rating checkbox when you refresh
#remember checkboxes when we go to more about movie, then use the back to movie link
#"Should" fix the sort under a rating issue as well (ie, sort the rating, then sort the movie title inside that rating)

class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
        
  def index
    @all_ratings = Movie.get_ratings()
    
    unless params[:ratings].nil?
        @checked_ratings = params[:ratings]
        session[:checked_ratings] = @checked_ratings
    end
    
    if params[:sort].nil?
    else
        session[:sort] = params[:sort]
    end
    
    if params[:sort].nil? && params[:ratings].nil? && session[:checked_ratings]
        @checked_ratings = session[:checked_ratings]
        @sort = session[:sort]
        flash.keep
        redirect_to movies_path({order_by: @sort, ratings: @checked_ratings})
    end
    
    @movies = Movie.all
    
    if session[:checked_ratings]
        @movies = @movies.select{ |movie| session[:checked_ratings].include? movie.rating}
    end
    
    case params[:sort]
    when 'title'
        @movies = Movie.order(params[:sort])
        @movie_highlight = 'hilite'     #created a class in movies/index.html.haml to use this, 'hilite from default.css'
    when 'release_date'
        @movies = Movie.order(params[:sort])    
        @release_highlight = 'hilite'   #created a class in movies/index.html.haml to use this, 'hilite from default.css'
    else
        params[:ratings] ? @movies = Movie.where(rating: params[:ratings].keys) : 
                           @movies = Movie.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
