#when reopening, use these commmands:
#rake db:drop
#rake db:create
#rake db:migrate
#rake db:seed

#QUESTION FOR COMPLETEION...PART 1 
#are my id: title_header and id: release_date_header under index.html.haml correct
#for the "IMPORTANT for grading purposes: Secion"

class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

#def index
    #@movies = Movie.all
#end
#case params[:sort]
#     when 'title'
#        @movies = Movie.order("title asc")
#        @title_hilite = 'hilite'
#    when 'release'
#        @movies = Movie.order("release_date asc")
#        @release_hilite = 'hilite'
#    else
        
  def index
    case params[:sort]
    when 'title'
        @movies = Movie.order(params[:sort])
        @movie_highlight = 'hilite'     #created a class in movies/index.html.haml to use this, 'hilite from default.css'
    when 'release_date'
        @movies = Movie.order(params[:sort])    
        @release_highlight = 'hilite'   #created a class in movies/index.html.haml to use this, 'hilite from default.css'
    else
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
