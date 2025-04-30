# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  before_action :authenticate_user!               # require login
  before_action :set_product, only: %i[show edit update destroy]

  # GET /products — list all products
  def index
    @products = policy_scope(Product).order(created_at: :desc)
  end

  # GET /products/:id — show single product
  def show
    authorize @product
  end

  # GET /products/new — show new form
  def new
    @product = current_user.products.build
    authorize @product
  end

  # POST /products — create a product
  def create
    @product = current_user.products.build(product_params)
    authorize @product

    if @product.save
      redirect_to @product, notice: "Product created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /products/:id/edit — show edit form
  def edit
    authorize @product
  end

  # PATCH/PUT /products/:id — update product
  def update
    authorize @product

    if @product.update(product_params)
      redirect_to @product, notice: "Product updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /products/:id — delete product
  def destroy
    authorize @product
    @product.destroy
    redirect_to products_path, notice: "Product was deleted."
  end

  private

  # allowed form fields
  def product_params
    params.require(:product).permit(:name, :description, :price, :active, :category_id, tag_ids: [])
  end

  # find product by id
  def set_product
    @product = Product.find(params[:id])
  end
end
