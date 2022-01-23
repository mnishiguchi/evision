defmodule OpenCV.Mat do
  @moduledoc """
  OpenCV Mat
  """

  @typedoc """
  Types for mat
  """
  @type mat_type ::
          {:u, 8}
          | {:u, 16}
          | {:s, 8}
          | {:s, 16}
          | {:f, 32}
          | {:f, 64}
  @type channels_from_binary ::
          1 | 3 | 4

  @doc namespace: :"cv.Mat"
  @spec type(reference()) :: {:ok, reference()} | {:error, String.t()}
  def type(mat) when is_reference(mat) do
    :erl_cv_nif.evision_cv_mat_type(img: mat)
  end

  @doc namespace: :"cv.Mat"
  @spec as_type(reference(), mat_type()) :: {:ok, reference()} | {:error, String.t()}
  def as_type(mat, _type={t, l}) when is_reference(mat) and is_atom(t) and l > 0 do
    :erl_cv_nif.evision_cv_mat_as_type(img: mat, t: t, l: l)
  end

  @doc namespace: :"cv.Mat"
  def shape(mat) when is_reference(mat) do
    :erl_cv_nif.evision_cv_mat_shape(img: mat)
  end

  @doc namespace: :"cv.Mat"
  @spec clone(reference()) :: {:ok, reference()} | {:error, String.t()}
  def clone(mat) when is_reference(mat) do
    :erl_cv_nif.evision_cv_mat_clone(img: mat)
  end

  @doc namespace: :"cv.Mat"
  @spec clone(reference()) :: {:ok, binary()} | {:error, String.t()}
  def to_binary(mat) when is_reference(mat) do
    :erl_cv_nif.evision_cv_mat_to_binary(img: mat)
  end

  @doc """
  Create Mat from binary (pixel) data

  - **binary**. The binary pixel data
  - **type**. `type={t, l}` is one of [{:u, 8}, {:s, 8}, {:u, 16}, {:s, 16}, {:s, 32}, {:f, 32}, {:f, 64}]
  - **rows**. Number of rows (i.e., the height of the image)
  - **cols**. Number of cols (i.e., the width of the image)
  - **channels**. Number of channels, only valid if in [1, 3, 4]
  """
  @doc namespace: :"cv.Mat"
  @spec from_binary(binary(), mat_type(), pos_integer(), pos_integer(), channels_from_binary()) :: {:ok, reference()} | {:error, String.t()}
  def from_binary(binary, _type = {t, l}, rows, cols, channels)
      when is_binary(binary) and rows > 0 and cols > 0 and channels > 0 and
             is_atom(t) and is_integer(l) do
    :erl_cv_nif.evision_cv_mat_from_binary(
      binary: binary,
      t: t,
      l: l,
      cols: cols,
      rows: rows,
      channels: channels
    )
  end

  @doc namespace: :"cv.Mat"
  def from_binary_by_shape(binary, _type = {t, l}, shape)
      when is_binary(binary) and is_atom(t) and is_integer(l) and is_tuple(shape) do
    from_binary_by_shape(binary, {t, l}, Tuple.to_list(shape))
  end

  @doc namespace: :"cv.Mat"
  def from_binary_by_shape(binary, _type = {t, l}, shape)
      when is_binary(binary) and is_atom(t) and is_integer(l) and is_list(shape) do
    :erl_cv_nif.evision_cv_mat_from_binary_by_shape(
      binary: binary,
      t: t,
      l: l,
      shape: shape
    )
  end
end
