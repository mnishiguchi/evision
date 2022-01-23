defmodule OpenCV.Nx do
  @moduledoc """
  OpenCV mat to Nx tensor. 

  `:nx` is an optional dependency, so if you want to use
  functions in `OpenCV.Nx`, you need to add it to the dependency
  list.
  """

  unless Code.ensure_loaded?(Nx) do
    @compile {:no_warn_undefined, Nx}
  end

  @doc """
  Transform an `OpenCV.Mat` reference to `Nx.tensor`.

  The resulting tensor is in the shape `{height, width, channels}`.

  ### Example

  ```elixir
  iex> {:ok, mat} = OpenCV.imread("/path/to/exist/img.png")
  iex> nx_tensor = OpenCV.Nx.to_nx(mat)
  ...> #Nx.Tensor<
  ...>    u8[1080][1920][3]
  ...>    [[ ... pixel data ... ]]
  ...> >
  ```
  """
  @doc namespace: :external
  @spec to_mat(reference()) :: {:ok, reference()} | {:error, String.t()}
  def to_nx(mat) do
    {:ok, mat_type} = OpenCV.Mat.type(mat)
    {:ok, mat_shape} = OpenCV.Mat.shape(mat)

    case OpenCV.Mat.to_binary(mat) do
      {:ok, bin} ->
        bin
        |> Nx.from_binary(mat_type)
        |> Nx.reshape(mat_shape)

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Converts a tensor of `Nx` to `Mat` of evision (OpenCV).

  If the tensor has three dimensions, it is expected
  to have shape`{height, width, channels}`.
  """
  @doc namespace: :external
  @spec to_mat(Nx.t()) :: {:ok, reference()} | {:error, String.t()}
  def to_mat(t) when is_struct(t, Nx.Tensor) do
    case Nx.shape(t) do
      {height, width, channels} ->
        to_mat(Nx.to_binary(t), Nx.type(t), height, width, channels)
    
      shape ->
        OpenCV.Mat.from_binary_by_shape(Nx.to_binary(t), Nx.type(t), shape)
    end
  end

  @spec to_mat(
          binary(),
          {atom(), pos_integer()},
          pos_integer(),
          pos_integer(),
          pos_integer()
        ) :: {:ok, reference()} | {:error, charlist()}
  defp to_mat(binary, type, cols, rows, channels) do
    OpenCV.Mat.from_binary(binary, type, cols, rows, channels)
  end
end
